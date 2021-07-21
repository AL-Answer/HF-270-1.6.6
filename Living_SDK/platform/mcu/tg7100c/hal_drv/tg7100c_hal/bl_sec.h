#ifndef __BL_SEC_H__
#define __BL_SEC_H__
#include <stddef.h>
#include <stdint.h>

//#include <FreeRTOS.h>
//#include <semphr.h>
#include <os_hal.h>

/* copied SEC_Eng_SHA256_Ctx from stddrv */
typedef struct {
    uint32_t total[2];
    uint32_t *shaBuf;
    uint32_t *shaPadding;
    uint8_t  shaFeed;
} _bl_sha_SEC_Eng_SHA256_Ctx_t;

/* copied SEC_ENG_SHA_Type from stddrv, SHA1_RSVD removed */
typedef enum {
    BL_SHA256,
    BL_SHA224,
    BL_SHA1,
} bl_sha_type_t;

typedef struct bl_sha_ctx {
    _bl_sha_SEC_Eng_SHA256_Ctx_t sha_ctx;
    uint32_t tmp[16];
    uint32_t pad[16];
} bl_sha_ctx_t;

//extern SemaphoreHandle_t g_bl_sec_sha_mutex;
extern os_mutex_t g_bl_sec_sha_mutex;

int bl_sec_init(void);
int bl_sec_test(void);
int bl_pka_test(void);
int bl_sec_aes_init(void);
int bl_sec_aes_enc(uint8_t *key, int keysize, uint8_t *input, uint8_t *output);
int bl_sec_aes_test(void);
uint32_t bl_sec_get_random_word(void);
void bl_rand_stream(uint8_t *buf, int len);
int bl_rand(void);
/*SHA Engine API*/
int bl_sec_sha_test(void);

int bl_sha_mutex_take();
int bl_sha_mutex_give();
void bl_sha_init(bl_sha_ctx_t *ctx, const bl_sha_type_t type);
int bl_sha_update(bl_sha_ctx_t *ctx, const uint8_t *input, uint32_t len);
int bl_sha_finish(bl_sha_ctx_t *ctx, uint8_t *hash);

#endif
