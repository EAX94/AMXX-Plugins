#if defined _adv_vault_included
  #endinput
#endif
#define _adv_vault_included


/*======================================*
[Advanced Vault System 1.3 by Destro]
*======================================*/

/*Tipos de datos*/
enum {
	DATATYPE_INT=0,
	DATATYPE_STRING,
	DATATYPE_ARRAY
}

enum (<<= 1) {
	CLEAR_ALL=1,
	CLEAR_DATA,
	CLEAR_INDEX,
	CLEAR_SIMPLEDATA,
}

enum (<<= 1) {
	FINDFLAGS_EQUAL=1,
	FINDFLAGS_CONTAIN,
	FINDFLAGS_CASE_SENSITIVE,
	FINDFLAGS_LESS,
	FINDFLAGS_GREATER,
	FINDFLAGS_NOT,
	FINDFLAGS_AND,
	FINDFLAGS_OR
}

/*Orden descendente/ascendente*/
enum {
	ORDER_DESC=0,
	ORDER_ASC
}


/*===================================*
[Chequea si el vault esta abierto]
-vaultname:
  nombre del vault
-return:
  Devuelve el index del vault
*===================================*/
native adv_vault_is_open(const vaultname[])


/*===================================*
[Abre/Crea un vault]
-vaultname:
  nombre del vault
-cache_index:
  guarda el indice key's en memoria
   (recomendado en uso masivo)
-return:
  Devuelve el index del vault
*===================================*/
native adv_vault_open(const vaultname[], cache_index=false)


/*==================*
[Inicializa el vault]
-vault:
  index del vault
*==================*/
native adv_vault_init(vault)

	
/*==============*
[Cierra un vault]
-vault:
  index del vault
*==============*/
native adv_vault_closed(vault)


/*==============*
[Limpia el fault]
-vault:
  index del vault
*==============*/
native adv_vault_clear(vault, flags)


/*==============*
[Devuelve la cantidad total de registros]
-vault:
  index del vault
-indexkey:
  si esta en true devuelve la cantidad de registros indexeados
*==============*/
native adv_vault_size(vault, indexkey=false)

/*============================================*
[Agrega un campo al vault]
-vault:
  index del vault
-fieldname:
  nombre del campo
-type:
  tipo de dato que se va a guardar
-length:
  tamaño reservado para guardar
   (solo para DATATYPE_STRING y DATATYPE_ARRAY)
-return:
  devuelve el index del campo(fieldindex)
*=============================================*/
native adv_vault_register_field(vault, const fieldname[], type=DATATYPE_INT, length=0)


/*=======================*
[Busca el index asociado al keyname]
-vault:
  index del vault
-return:
  devuelve 0 si no se encontro el keyindex,
   de lo contrario devuelve el keyindex
*=======================*/
native adv_vault_get_keyindex(vault, const keyname[])


/*=======================*
[Busca el keyname asociado al keyindex]
-vault:
  index del vault
-output:
  variable de salida
-len:
  tamaño de salida
-return:
  devuelve 1 si se encontro el keyname,de lo contrario 0
*=======================*/
native adv_vault_get_keyname(vault, keyindex, output[], len)


/*========================================*
[Prepara la obtención de datos]
-vault:
  index del vault
-keyindex:
  el index de un key (recomendado)
-keyname:
  key (internamente busca el index del key)
-return:
  devuelve 1 si hay datos,de lo contrario 0
*========================================*/
native adv_vault_get_prepare(vault, keyindex=0, const keyname[]="")


/*============================================*
[Obtiene los datos de un campo]
-vault:
  index del vault
-fieldindex:
  index del campo
-output:
  variable de salida
-len:
  tamaño de salida
-return:
  si es DATATYPE_INT devuelve el valor guardado
*============================================*/
native adv_vault_get_field(vault, fieldindex, output[]="", len=0)
	
	
/*======================================*
[Prepara todo para modificar los campos]
-vault:
  index del vault
*=====================================*/
native adv_vault_set_start(vault)


/*============================================================*
[Modifica el campo]
-vault:
  index del vault
-fieldindex:
  index del campo
-value:
  DATATYPE_INT: un valor numerico
  DATATYPE_STRING: un string normal o para formatear (%s %d...)
  DATATYPE_ARRAY: un array
*============================================================*/
native adv_vault_set_field(vault, fieldindex, any:...)


/*=========================================================*
[Actualiza/Inserta los campos modificados]
-vault:
  index del vault
-keyindex:
  el index de un key (recomendado)
-keyname:
  key (internamente busca el index del key)
-return:
  devuelve el keyindex
 
Usar keyindex 0 y keyname "" para insertar un nuevo dato
   con un index auto-incrementado
*=========================================================*/
native adv_vault_set_end(vault, keyindex=0, const keyname[]="")


/*========================================================*
[Remueve una clave]
-vault:
  index del vault
-keyindex:
  el index de un key (recomendado)
-keyname:
  key (internamente busca el index del key)

Si se usa keyname se remueve la clave del indice y el dato
Si se usa keyindex solo se remueve el dato
*========================================================*/
native adv_vault_removekey(vault, keyindex=0, const keyname[]="")


/*=================================================*
[La forward es llamada cuando se cierra un Vault---]
*==================================================*/
forward fw_adv_vault_closed(vault)


/*===========================================================================*
[Busqueda -------------------------------------------------------------------]
*===========================================================================*/





/*===========================================================================*
[Ordenamiento ---------------------------------------------------------------]
*===========================================================================*/
/*===========================*
[Inicia una busqueda]
-vault:
  index del vault
-Any:
  (field, flags, value)
    *Field: El index del campo a comparar
    *Value: El valor con el cual comparar
    *Frags: Las sentencias de comparacion
*===========================*/
native adv_vault_find_start(vault, any:...)

/*===========================*
[Busca el siguiente resultado]
-vault:
  index del vault
*===========================*/
native adv_vault_find_next(vault)

/*===========================*
[Finaliza la busqueda]
-vault:
  index del vault
*===========================*/
native adv_vault_find_closed(vault)


/*======================================================================*
[Crea un ordenamiento]
-vault:
  index del vault
-order:
  el orden (ORDER_DESC/ORDER_ASC)
-refresh:
  tiempo en seguando para actualizar el ordenamiento (0 para desactivar)
-maxlimit:
  limite maximo de resultados (0 ilimitado)
-any:
  los campos tipo INT que se usaran para ordenar (maximo 4)
-return:
  devuelve el keyindex
 
Usar keyindex 0 y keyname "" para insertar un nuevo dato
   devuelve el index del sort
*======================================================================*/
native adv_vault_sort_create(vault, order, refresh, maxlimit, any:...)


/*===========================*
[Actualiza un ordenamiento]
-vault:
  index del vault
-sort:
  index del ordenamiento
*===========================*/
native adv_vault_sort_update(vault, sort)


/*===========================*
[Destruye un ordenamiento]
-vault:
  index del vault
-sort:
  index del ordenamiento
*===========================*/
native adv_vault_sort_destroy(vault, sort)


/*===============================================*
[Devuelve la posicion de un key]
-vault:
  index del vault
-sort:
  index del ordenamiento
 -keyindex:
  el index de un key (recomendado)
-keyname:
  key (internamente busca el index del key)
-return:
  devuelve la posicion del key en el ordenamiento,si no se encuentra el key devuelve 0
*===============================================*/
native adv_vault_sort_key(vault, sort, keyindex, const keyname[]="")


/*===============================================*
[Devuelve el indexkey de una posicion]
-vault:
  index del vault
-sort:
  index del ordenamiento
-position:
  la pocicion (de 1 a RESULTNUM)
-return:
  devuelve el indexkey de una posicion
*===============================================*/
native adv_vault_sort_position(vault, sort, position)


/*=================================*
[Devuelve el numero de resultados]
-vault:
  index del vault
-sort:
  index del ordenamiento
-return:
  devuelve el numero de resultados
*=================================*/
native adv_vault_sort_numresult(vault, sort)


/*=================================================*
[La forward es llamada cuando se actualiza el Sort]
*==================================================*/
forward fw_adv_vault_sort_update(vault, sort)


/*=======================================================================*
[Simple Vault -----------------------------------------------------------]
*=======================================================================*/
// Obtiene lo datos de una clave
native adv_vault_simple_get(vault, const key[], output[], len)

// Guarda los datos en una clave
native adv_vault_simple_set(vault, const key[], const data[], any:...)

// Remueve una clave
native adv_vault_simple_removekey(vault, const key[])

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang11274\\ f0\\ fs16 \n\\ par }
*/
