#if defined _mysqlt_included
  #endinput
#endif
#define _mysqlt_included
#if AMXX_VERSION_NUM >= 175
 #pragma reqclass mysqlt
 #if !defined AMXMODX_NOAUTOLOAD
  #pragma defclasslib mysqlt mysqlt
 #endif
#endif

//#define OLDNATIVES_COMPACTIBILITY


#if !defined _sqlx_included
enum
{
	TQUERY_CONNECT_FAILED=-2,
	TQUERY_QUERY_FAILED=-1,
	TQUERY_SUCCESS=0,
};

enum Handle
{
   Empty_Handle
};

#endif

/*
[Configura la performance del ThreadsQuery]
 -collect_time:
   Tiempo en milisegundos en el que se recolectan los datos listos
 -th_think_time:
   Tiempo en milisegundos para el proximo frame del Thread
 -threads_per_frame:
   Cantidad de Threads simultaneamente
*/
native mysql_performance(collect_time=100, th_think_time=100, threads_per_frame=1);


/*
[Realiza una consulta]
 -cn_handler:
   El handler devuelto por mysql_makehost o mysql_connect.
 -handler:
   La funcion que sera llamada al finalizar la consulta
 -query:
   La consulta
 -data:
   Array para pasar algun dato a la funcion handler
 -datasize:
   Tamaño del array data
----------------------------------------------------------------------------------
La funcion handler tiene este formato:
*public query_handler(failstate, error[], errnum, data[], size, Float:queuetime)
 -failstate:
   Estado de la consulta:
      TQUERY_CONNECT_FAILED: Fallo la conexión
      TQUERY_QUERY_FAILED: Fallo la consulta
      TQUERY_SUCCESS: Todo OK :P
 -error:
   String del error
 -errnum:
   Codigo del error
 -data:
   Datos pasados desde mysql_query
 -size:
   Tamaño del array data
 -queuetime:
   Tiempo transcurrido desde que se creo la consulta hasta que finalizo
  
*/
native mysql_query(Handle:cn_handler, const handler[], const query[], const data[]="", datasize=0);

/*
[Crea un identificador a un Host]
 return: Devuelve el Handle de un Host
*/
native Handle:mysql_makehost(const host[], const user[], const pass[], const db[], timeout=0);

/*[Libera el Handle de un Host o de una Conexión]*/
native mysql_free(Handle:_handle);

/*
[Crea una conexión permanente con el servidor MySQL]
 return: Devuelve el Handle de la Conexión
*/
native Handle:mysql_connect(Handle:host_handler, &errcode, error[], maxlength);

/*
[Comprueba si hay mas resultados]
 return: Devuelve true si hay mas resultados,de lo contrario false
*/
native mysql_more_results();

/*
[Comprueba si una columna no tiene un valor]
 return: Devuelve true si no tiene un valor,de lo contrario false
*/
native mysql_isnull(column);

/*
[Obtiene los datos de una columna(ID)]
 -column:
   El id de la columna
   
 Ejemplo:
   -Para numeros:
       new num = mysql_read_result(0)
       
   -Para Float:
       new Float:num2
       mysql_read_result(1, num2)
   -Para String:
       new str[32]
       mysql_read_result(2, str, 31)
*/
native mysql_read_result(column, {Float,_}:...);

/*
[Obtiene los datos de una columna(Name)]
 -name:
   El nombre de la columna
   
 Ejemplo:
   -Para numeros:
       new num = mysql_read_result2("columna1")
       
   -Para Float:
       new Float:num2
       mysql_read_result2("columna2", num2)
   -Para String:
       new str[32]
       mysql_read_result2("columna3", str, 31)
*/
native mysql_read_result2(name[], {Float,_}:...);

/*[Avanza al siguiente resultado]*/
native mysql_next_row();

/*[Devuelve el numero de campos afectados]*/
native mysql_affected_rows();

/*[Devuelve el numero de resultados]*/
native mysql_num_results();

/*[Devuelve el numero de columnas]*/
native mysql_num_columns();

/*[Se obtiene el nombre de una columna]*/
native mysql_fieldnumtoname(num, name[], maxlength);

/*[Se obtiene el id de una columna]*/
native mysql_fieldnametonum(const name[]);

/*[Se obtiene el ID del autoincrement si se inserto un campo nuevo]*/
native mysql_get_insert_id();

/*[Se obtiene la consulta del ThreadsQuery]*/
native mysql_get_query(buffer[], maxlength);

/*[Vuelve atras un resultado]*/
native mysql_rewind();


native mysql_next_result_set();

native mysql_escape_string(buffer[], buflen, const string[]);
native mysql_escape_string2(buffer[], buflen, const fmt[], any:...);