#include <stdio.h>
#include "scheduler.h"

// traccia i messaggi, variabile globale
int _id = 0;

// inizializza messaggi nuovi con id univoco
message::message(void) {
  id = _id++;
}

void scheduler::insert(message *e) {
  message **l;
  
  // cerca un messaggio con tempo di scheduling maggiore
  for( l = &head ; *l ; l = &((*l)->next) )
    if( (*l)->time > e->time )
      break;
  
  // se evento trovato, aggancialo, altrimenti lo scheduler era vuoto
  if( *l )
    e->next = ( *l );
  else
    e->next = NULL;
  
  // appende nuovo evento e seguito
  *l = e;
}

// ritorna il primo messaggio senza eliminarlo
message *scheduler::pop(void) {
  // ritorna il primo messaggio
  message *ret = head;

  // sgancia il primo messaggio
  if( head )
    head = head->next;

  return ret;
}

// analizza tutta la lista, es. debug a fine simulazione
void scheduler::walk(void) {
  message *l;
  for( l = head ; l ; l = l->next )
    printf("id=%d, time=%f\n", l->id, l->time );
}
