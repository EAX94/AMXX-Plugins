#if defined _cl_buy_included
  #endinput
#endif
#define _cl_buy_included

#pragma reqlib cl_buy

#define CSW_DEFUSER		33
#define CSW_NVGS		34
#define CSW_SHIELD		35
#define CSW_PRIMAMMO	36
#define CSW_SECAMMO		37

forward client_buy(id, item);