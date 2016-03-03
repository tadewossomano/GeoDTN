""" GLCustomViewWidget.py - customization of pyqtgraph's qglwidget for some interaction needs

  This module is copied from the GLViewWidget implemented in pyqtgraph so that it can be easily
  customized for different needs (such as different mouse interactions etc).

  Last update: 08/10/2013, Marco Centin (marco.centin@gmail.com)
  - added a color picking function associated with right mouse click button
    see the part of the code marked with [colorpicking] for more details

"""

from pyqtgraph.Qt import QtCore, QtGui, QtOpenGL
from OpenGL.GL import *
import numpy as np
from pyqtgraph import Vector

class GLCustomViewWidget(QtOpenGL.QGLWidget):

    """ QGLWidget for visualizing 3D data

      Supporting rotation/scale controls, axis/grid display, export options.

    """

    ShareWidget = None

    def __init__(self, parent=None):

        if GLCustomViewWidget.ShareWidget is None:
            # A dummy widget to allow sharing objects (textures, shaders, etc) between views
            GLCustomViewWidget.ShareWidget = QtOpenGL.QGLWidget()

        QtOpenGL.QGLWidget.__init__(self, parent, GLCustomViewWidget.ShareWidget)

        self.setFocusPolicy(QtCore.Qt.ClickFocus)

        self.opts = {
            'center': Vector(0,0,0),  ## will always appear at the center of the widget
            'distance': 10.0,         ## distance of camera from center
            'fov':  60,               ## horizontal field of view in degrees
            'elevation':  30,         ## camera's angle of elevation in degrees
            'azimuth': 45,            ## camera's azimuthal angle in degrees
                                      ## (rotation around z-axis 0 points along x-axis)
        }

        self.noRepeatKeys = [ QtCore.Qt.Key_Right, QtCore.Qt.Key_Left, QtCore.Qt.Key_Up,
            QtCore.Qt.Key_Down, QtCore.Qt.Key_PageUp, QtCore.Qt.Key_PageDown]

        self.items = []
        self.keysPressed = {}
        self.keyTimer = QtCore.QTimer()
        self.keyTimer.timeout.connect(self.evalKeyState)
        
        #---B [colorpicking]
        self.picked_color = None
        #---E

        self.makeCurrent()


    def addItem(self, item):
        self.items.append(item)
        if hasattr(item, 'initializeGL'):
            self.makeCurrent()
            try:
                item.initializeGL()
            except:
                self.checkOpenGLVersion('Error while adding item %s to GLViewWidget.' % str(item))

        item._setView(self)
        #print "set view", item, self, item.view()
        self.update()

    def removeItem(self, item):
        self.items.remove(item)
        item._setView(None)
        self.update()


    def initializeGL(self):
        glClearColor(0.0, 0.0, 0.0, 0.0)        
        self.resizeGL(self.width(), self.height())

    def resizeGL(self, w, h):
        glViewport(0, 0, w, h)
        #self.update()

    def setProjection(self):
        # Create the projection matrix
        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()
        w = self.width()
        h = self.height()
        dist = self.opts['distance']
        fov = self.opts['fov']

        nearClip = dist * 0.001
        farClip = dist * 1000.

        r = nearClip * np.tan(fov * 0.5 * np.pi / 180.)
        t = r * h / w
        glFrustum( -r, r, -t, t, nearClip, farClip)

    def setModelview(self):
        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        glTranslatef( 0.0, 0.0, -self.opts['distance'])
        glRotatef(self.opts['elevation']-90, 1, 0, 0)
        glRotatef(self.opts['azimuth']+90, 0, 0, -1)
        center = self.opts['center']
        glTranslatef(-center.x(), -center.y(), -center.z())


    def paintGL(self):
        self.setProjection()
        self.setModelview()
        glClear( GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT )
        self.drawItemTree()

    def drawItemTree(self, item=None):
        if item is None:
            items = [x for x in self.items if x.parentItem() is None]
        else:
            items = item.childItems()
            items.append(item)
        items.sort(lambda a,b: cmp(a.depthValue(), b.depthValue()))
        for i in items:
            if not i.visible():
                continue
            if i is item:
                try:
                    glPushAttrib(GL_ALL_ATTRIB_BITS)
                    i.paint()
                except:
                    import pyqtgraph.debug
                    pyqtgraph.debug.printExc()
                    msg = "Error while drawing item %s." % str(item)
                    ver = glGetString(GL_VERSION)
                    if ver is not None:
                        ver = ver.split()[0]
                        if int(ver.split('.')[0]) < 2:
                            print(msg + " The original exception is printed above; however," +
                            " pyqtgraph requires OpenGL version 2.0 or greater for many of its" +
                            " 3D features and your OpenGL version is %s. Installing updated" +
                            " display drivers may resolve this issue." % ver)
                        else:
                            print(msg)

                finally:
                    glPopAttrib()
            else:
                glMatrixMode(GL_MODELVIEW)
                glPushMatrix()
                try:
                    tr = i.transform()
                    a = np.array(tr.copyDataTo()).reshape((4,4))
                    glMultMatrixf(a.transpose())
                    self.drawItemTree(i)
                finally:
                    glMatrixMode(GL_MODELVIEW)
                    glPopMatrix()

    def setCameraPosition(self, pos=None, distance=None, elevation=None, azimuth=None):
        if distance is not None:
            self.opts['distance'] = distance
        if elevation is not None:
            self.opts['elevation'] = elevation
        if azimuth is not None:
            self.opts['azimuth'] = azimuth
        self.update()



    def cameraPosition(self):
        """Return current position of camera based on center, dist, elevation, and azimuth"""
        center = self.opts['center']
        dist = self.opts['distance']
        elev = self.opts['elevation'] * np.pi/180.
        azim = self.opts['azimuth'] * np.pi/180.

        pos = Vector(
            center.x() + dist * np.cos(elev) * np.cos(azim),
            center.y() + dist * np.cos(elev) * np.sin(azim),
            center.z() + dist * np.sin(elev)
        )

        return pos

    def orbit(self, azim, elev):
        """Orbits the camera around the center position. *azim* and *elev* are given in degrees."""
        self.opts['azimuth'] += azim
        self.opts['elevation'] = np.clip(self.opts['elevation'] + elev, -90, 90)
        self.update()

    def pan(self, dx, dy, dz, relative=False):
        """
        Moves the center (look-at) position while holding the camera in place.

        If relative=True, then the coordinates are interpreted such that x
        if in the global xy plane and points to the right side of the view, y is
        in the global xy plane and orthogonal to x, and z points in the global z
        direction. Distances are scaled roughly such that a value of 1.0 moves
        by one pixel on screen.

        """
        if not relative:
            self.opts['center'] += QtGui.QVector3D(dx, dy, dz)
        else:
            cPos = self.cameraPosition()
            cVec = self.opts['center'] - cPos
            # Distance from camera to center
            dist = cVec.length()
            # Approx. width of view at distance of center point
            xDist = dist * 2. * np.tan(0.5 * self.opts['fov'] * np.pi / 180.)
            xScale = xDist / self.width()
            zVec = QtGui.QVector3D(0,0,1)
            xVec = QtGui.QVector3D.crossProduct(zVec, cVec).normalized()
            yVec = QtGui.QVector3D.crossProduct(xVec, zVec).normalized()
            self.opts['center'] = self.opts['center'] + \
                xVec*xScale*dx + yVec*xScale*dy + zVec*xScale*dz
        self.update()

    def pixelSize(self, pos):
        """
        Return the approximate size of a screen pixel at the location pos
        Pos may be a Vector or an (N,3) array of locations
        """
        cam = self.cameraPosition()
        if isinstance(pos, np.ndarray):
            cam = np.array(cam).reshape((1,)*(pos.ndim-1)+(3,))
            dist = ((pos-cam)**2).sum(axis=-1)**0.5
        else:
            dist = (pos-cam).length()
        xDist = dist * 2. * np.tan(0.5 * self.opts['fov'] * np.pi / 180.)
        return xDist / self.width()

    def mousePressEvent(self, ev):
        
        self.mousePos = ev.pos()

        #---B [colorpicking]
        if ev.buttons() == QtCore.Qt.RightButton:        
            _, _, width, height = glGetIntegerv( GL_VIEWPORT )
            glx, gly = self.mousePos.x(), height-self.mousePos.y()
            pick =  glReadPixels(glx, gly, 1, 1, GL_RGB, GL_FLOAT)
            pick = glReadPixels(glx, gly, 1, 1, GL_RGB, GL_FLOAT)
            pick = np.reshape(pick, 3)
            self.picked_color = pick
        #---E

    def mouseMoveEvent(self, ev):        
        diff = ev.pos() - self.mousePos
        self.mousePos = ev.pos()

        if ev.buttons() == QtCore.Qt.LeftButton:
            self.orbit(-diff.x(), diff.y())
            #print self.opts['azimuth'], self.opts['elevation']
        elif ev.buttons() == QtCore.Qt.MidButton:
            if (ev.modifiers() & QtCore.Qt.ControlModifier):
                self.pan(diff.x(), 0, diff.y(), relative=True)
            else:
                self.pan(diff.x(), diff.y(), 0, relative=True)

    def mouseReleaseEvent(self, ev):
        pass

    def wheelEvent(self, ev):
        if (ev.modifiers() & QtCore.Qt.ControlModifier):
            self.opts['fov'] *= 0.999**ev.delta()
        else:
            self.opts['distance'] *= 0.999**ev.delta()
        self.update()

    def keyPressEvent(self, ev):
        if ev.key() in self.noRepeatKeys:
            ev.accept()
            if ev.isAutoRepeat():
                return
            self.keysPressed[ev.key()] = 1
            self.evalKeyState()

    def keyReleaseEvent(self, ev):
        if ev.key() in self.noRepeatKeys:
            ev.accept()
            if ev.isAutoRepeat():
                return
            try:
                del self.keysPressed[ev.key()]
            except:
                self.keysPressed = {}
            self.evalKeyState()

    def evalKeyState(self):
        speed = 2.0
        if len(self.keysPressed) > 0:
            for key in self.keysPressed:
                if key == QtCore.Qt.Key_Right:
                    self.orbit(azim=-speed, elev=0)
                elif key == QtCore.Qt.Key_Left:
                    self.orbit(azim=speed, elev=0)
                elif key == QtCore.Qt.Key_Up:
                    self.orbit(azim=0, elev=-speed)
                elif key == QtCore.Qt.Key_Down:
                    self.orbit(azim=0, elev=speed)
                elif key == QtCore.Qt.Key_PageUp:
                    pass
                elif key == QtCore.Qt.Key_PageDown:
                    pass
                self.keyTimer.start(16)
        else:
            self.keyTimer.stop()

    def checkOpenGLVersion(self, msg):
        # Only to be called from within exception handler.
        ver = glGetString(GL_VERSION).split()[0]
        if int(ver.split('.')[0]) < 2:
            import pyqtgraph.debug
            pyqtgraph.debug.printExc()
            raise Exception( msg +
                " The original exception is printed above; however, pyqtgraph requires OpenGL" +
                " version 2.0 or greater for many of its 3D features and your OpenGL version is" +
                " %s. Installing updated display drivers may resolve this issue." % ver)
        else:
            raise


