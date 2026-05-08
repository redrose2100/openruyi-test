#include <linux/if_alg.h>
#include <linux/socket.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#ifndef SOL_ALG
#define SOL_ALG 279
#endif

int main(void) {
  int opfd_enc, opfd_dec;
  int tfmfd;
  struct sockaddr_alg sa = {
    .salg_family = AF_ALG,
    .salg_type = "skcipher",
    .salg_name = "cbc(sm4)"
  };
  struct msghdr msg = {};
  char cbuf[CMSG_SPACE(4) + CMSG_SPACE(20)] = {0};
  char enc_buf[16], dec_buf[16];
  struct af_alg_iv *iv;
  struct iovec iov;
  int i;

  // 创建算法套接字
  tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
  bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));

  // 设置密钥
  setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY,
             "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
             "\x51\x2e\x03\xd5\x34\x12\x00\x06",
             16);

  /******************** 加密操作 ********************/
  opfd_enc = accept(tfmfd, NULL, 0);

  // 设置消息头
  msg.msg_control = cbuf;
  msg.msg_controllen = sizeof(cbuf);

  // 设置加密操作
  struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
  cmsg->cmsg_level = SOL_ALG;
  cmsg->cmsg_type = ALG_SET_OP;
  cmsg->cmsg_len = CMSG_LEN(4);
  *(__u32 *)CMSG_DATA(cmsg) = ALG_OP_ENCRYPT;

  // 设置IV
  cmsg = CMSG_NXTHDR(&msg, cmsg);
  cmsg->cmsg_level = SOL_ALG;
  cmsg->cmsg_type = ALG_SET_IV;
  cmsg->cmsg_len = CMSG_LEN(20);
  iv = (void *)CMSG_DATA(cmsg);
  iv->ivlen = 16;
  memcpy(iv->iv,
         "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
         "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
         16);

  // 设置明文数据
  iov.iov_base = "Hello SM4 加密";
  iov.iov_len = 16;
  msg.msg_iov = &iov;
  msg.msg_iovlen = 1;

  // 执行加密
  sendmsg(opfd_enc, &msg, 0);
  read(opfd_enc, enc_buf, 16);

  printf("加密结果: ");
  for (i = 0; i < 16; i++)
    printf("%02x", (unsigned char)enc_buf[i]);
  printf("\n");

  close(opfd_enc);

  /******************** 解密操作 ********************/
  opfd_dec = accept(tfmfd, NULL, 0);

  // 重置控制消息缓冲区
  memset(cbuf, 0, sizeof(cbuf));
  struct msghdr msg_dec = {};
  msg_dec.msg_control = cbuf;
  msg_dec.msg_controllen = sizeof(cbuf);

  // 设置解密操作
  cmsg = CMSG_FIRSTHDR(&msg_dec);
  cmsg->cmsg_level = SOL_ALG;
  cmsg->cmsg_type = ALG_SET_OP;
  cmsg->cmsg_len = CMSG_LEN(4);
  *(__u32 *)CMSG_DATA(cmsg) = ALG_OP_DECRYPT;

  // 设置相同IV
  cmsg = CMSG_NXTHDR(&msg_dec, cmsg);
  cmsg->cmsg_level = SOL_ALG;
  cmsg->cmsg_type = ALG_SET_IV;
  cmsg->cmsg_len = CMSG_LEN(20);
  iv = (void *)CMSG_DATA(cmsg);
  iv->ivlen = 16;
  memcpy(iv->iv,
         "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
         "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
         16);

  // 设置密文数据
  struct iovec iov_dec;
  iov_dec.iov_base = enc_buf;
  iov_dec.iov_len = 16;
  msg_dec.msg_iov = &iov_dec;
  msg_dec.msg_iovlen = 1;

  // 执行解密
  sendmsg(opfd_dec, &msg_dec, 0);
  read(opfd_dec, dec_buf, 16);

  printf("解密结果: ");
  for (i = 0; i < 16; i++)
    printf("%c", dec_buf[i]);
  printf("\n");

  close(opfd_dec);
  close(tfmfd);

  return 0;
}