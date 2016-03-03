// dichiarazione della nuova classe
class message {
public:  	
  // costruttore	
  message(void);

  // tempo di scheduling
  double   	time;

  // id dell'evento
  int      	id;

  // id dell'handler per gestione messaggio
  int      	handler;

  // dato comprensibile all'handler
  int      	data;

  // puntatore al messaggio successivo
  message* 	next;
};

class scheduler {
public:
  // costruttore
  scheduler(void) : head(NULL) {};
  
  // primo messaggio
  message* head;

  // inserisce messaggio
  void     insert(message*);

  // estrare primo messaggio
  message* pop(void);

  // visita eventi
  void     walk(void);
};

