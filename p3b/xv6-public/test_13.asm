
_test_13:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
   ppid = getpid();
  14:	e8 4a 08 00 00       	call   863 <getpid>

   assert(fib(28) == 317811);
  19:	83 ec 0c             	sub    $0xc,%esp
  1c:	6a 1c                	push   $0x1c
   ppid = getpid();
  1e:	a3 4c 11 00 00       	mov    %eax,0x114c
   assert(fib(28) == 317811);
  23:	e8 18 01 00 00       	call   140 <fib>
  28:	83 c4 10             	add    $0x10,%esp
  2b:	3d 73 d9 04 00       	cmp    $0x4d973,%eax
  30:	0f 85 92 00 00 00    	jne    c8 <main+0xc8>

   int arg1 = 11, arg2 = 22;

   for (int i = 0; i < num_threads; i++) {
  36:	83 3d 44 11 00 00 00 	cmpl   $0x0,0x1144
   int arg1 = 11, arg2 = 22;
  3d:	c7 45 e0 0b 00 00 00 	movl   $0xb,-0x20(%ebp)
  44:	c7 45 e4 16 00 00 00 	movl   $0x16,-0x1c(%ebp)
   for (int i = 0; i < num_threads; i++) {
  4b:	0f 8e d3 00 00 00    	jle    124 <main+0x124>
  51:	31 db                	xor    %ebx,%ebx
  53:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  56:	8d 75 e0             	lea    -0x20(%ebp),%esi
  59:	eb 11                	jmp    6c <main+0x6c>
  5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  5f:	90                   	nop
  60:	a1 44 11 00 00       	mov    0x1144,%eax
  65:	83 c3 01             	add    $0x1,%ebx
  68:	39 d8                	cmp    %ebx,%eax
  6a:	7e 79                	jle    e5 <main+0xe5>
      int thread_pid = thread_create(worker, &arg1, &arg2);
  6c:	83 ec 04             	sub    $0x4,%esp
  6f:	57                   	push   %edi
  70:	56                   	push   %esi
  71:	68 50 03 00 00       	push   $0x350
  76:	e8 a5 06 00 00       	call   720 <thread_create>
      assert(thread_pid > 0);
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	85 c0                	test   %eax,%eax
  80:	7f de                	jg     60 <main+0x60>
  82:	6a 2e                	push   $0x2e
  84:	68 78 0c 00 00       	push   $0xc78
  89:	68 82 0c 00 00       	push   $0xc82
  8e:	6a 01                	push   $0x1
  90:	e8 bb 08 00 00       	call   950 <printf>
  95:	83 c4 0c             	add    $0xc,%esp
  98:	68 20 0d 00 00       	push   $0xd20
  9d:	68 95 0c 00 00       	push   $0xc95
  a2:	6a 01                	push   $0x1
  a4:	e8 a7 08 00 00       	call   950 <printf>
  a9:	58                   	pop    %eax
  aa:	5a                   	pop    %edx
  ab:	68 a9 0c 00 00       	push   $0xca9
  b0:	6a 01                	push   $0x1
  b2:	e8 99 08 00 00       	call   950 <printf>
  b7:	59                   	pop    %ecx
  b8:	ff 35 4c 11 00 00    	push   0x114c
  be:	e8 50 07 00 00       	call   813 <kill>
  c3:	e8 1b 07 00 00       	call   7e3 <exit>
   assert(fib(28) == 317811);
  c8:	6a 28                	push   $0x28
  ca:	68 78 0c 00 00       	push   $0xc78
  cf:	68 82 0c 00 00       	push   $0xc82
  d4:	6a 01                	push   $0x1
  d6:	e8 75 08 00 00       	call   950 <printf>
  db:	83 c4 0c             	add    $0xc,%esp
  de:	68 01 0d 00 00       	push   $0xd01
  e3:	eb b8                	jmp    9d <main+0x9d>
   }

   for (int i = 0; i < num_threads; i++) {
  e5:	85 c0                	test   %eax,%eax
  e7:	7e 3b                	jle    124 <main+0x124>
  e9:	31 db                	xor    %ebx,%ebx
  eb:	eb 0e                	jmp    fb <main+0xfb>
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c3 01             	add    $0x1,%ebx
  f3:	39 1d 44 11 00 00    	cmp    %ebx,0x1144
  f9:	7e 29                	jle    124 <main+0x124>
      int join_pid = thread_join();
  fb:	e8 50 06 00 00       	call   750 <thread_join>
      assert(join_pid > 0);
 100:	85 c0                	test   %eax,%eax
 102:	7f ec                	jg     f0 <main+0xf0>
 104:	6a 33                	push   $0x33
 106:	68 78 0c 00 00       	push   $0xc78
 10b:	68 82 0c 00 00       	push   $0xc82
 110:	6a 01                	push   $0x1
 112:	e8 39 08 00 00       	call   950 <printf>
 117:	83 c4 0c             	add    $0xc,%esp
 11a:	68 2f 0d 00 00       	push   $0xd2f
 11f:	e9 79 ff ff ff       	jmp    9d <main+0x9d>
   }

   printf(1, "TEST PASSED\n");
 124:	53                   	push   %ebx
 125:	53                   	push   %ebx
 126:	68 13 0d 00 00       	push   $0xd13
 12b:	6a 01                	push   $0x1
 12d:	e8 1e 08 00 00       	call   950 <printf>
   exit();
 132:	e8 ac 06 00 00       	call   7e3 <exit>
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <fib>:
unsigned int fib(unsigned int n) {
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
 146:	83 ec 4c             	sub    $0x4c,%esp
   if (n == 0) {
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	85 c0                	test   %eax,%eax
 14e:	0f 84 7d 01 00 00    	je     2d1 <fib+0x191>
   } else if (n == 1) {
 154:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 158:	0f 84 73 01 00 00    	je     2d1 <fib+0x191>
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
 168:	89 45 d8             	mov    %eax,-0x28(%ebp)
      return fib(n - 1) + fib(n - 2);
 16b:	8b 45 d8             	mov    -0x28(%ebp),%eax
 16e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 175:	83 e8 01             	sub    $0x1,%eax
 178:	89 45 b8             	mov    %eax,-0x48(%ebp)
   } else if (n == 1) {
 17b:	8b 45 b8             	mov    -0x48(%ebp),%eax
 17e:	83 f8 01             	cmp    $0x1,%eax
 181:	0f 84 2c 01 00 00    	je     2b3 <fib+0x173>
      return fib(n - 1) + fib(n - 2);
 187:	83 e8 01             	sub    $0x1,%eax
 18a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 191:	89 45 b4             	mov    %eax,-0x4c(%ebp)
   } else if (n == 1) {
 194:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 197:	83 f8 01             	cmp    $0x1,%eax
 19a:	0f 84 90 01 00 00    	je     330 <fib+0x1f0>
      return fib(n - 1) + fib(n - 2);
 1a0:	83 e8 01             	sub    $0x1,%eax
 1a3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
 1aa:	89 45 ac             	mov    %eax,-0x54(%ebp)
   } else if (n == 1) {
 1ad:	8b 45 ac             	mov    -0x54(%ebp),%eax
 1b0:	83 f8 01             	cmp    $0x1,%eax
 1b3:	0f 84 5e 01 00 00    	je     317 <fib+0x1d7>
      return fib(n - 1) + fib(n - 2);
 1b9:	83 e8 01             	sub    $0x1,%eax
 1bc:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 1c3:	89 45 b0             	mov    %eax,-0x50(%ebp)
   } else if (n == 1) {
 1c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
 1c9:	83 f8 01             	cmp    $0x1,%eax
 1cc:	0f 84 3c 01 00 00    	je     30e <fib+0x1ce>
      return fib(n - 1) + fib(n - 2);
 1d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1d9:	8d 48 ff             	lea    -0x1(%eax),%ecx
 1dc:	89 cb                	mov    %ecx,%ebx
   } else if (n == 1) {
 1de:	83 fb 01             	cmp    $0x1,%ebx
 1e1:	0f 84 13 01 00 00    	je     2fa <fib+0x1ba>
      return fib(n - 1) + fib(n - 2);
 1e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
 1ea:	83 eb 02             	sub    $0x2,%ebx
 1ed:	31 c9                	xor    %ecx,%ecx
 1ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
 1f2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
 1f5:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
   } else if (n == 1) {
 1f8:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
 1fc:	0f 84 01 01 00 00    	je     303 <fib+0x1c3>
 202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 205:	31 c0                	xor    %eax,%eax
 207:	89 d7                	mov    %edx,%edi
 209:	89 c2                	mov    %eax,%edx
 20b:	83 ff 01             	cmp    $0x1,%edi
 20e:	0f 84 dc 00 00 00    	je     2f0 <fib+0x1b0>
      return fib(n - 1) + fib(n - 2);
 214:	89 7d c0             	mov    %edi,-0x40(%ebp)
 217:	8d 5f ff             	lea    -0x1(%edi),%ebx
 21a:	31 f6                	xor    %esi,%esi
 21c:	89 cf                	mov    %ecx,%edi
   } else if (n == 1) {
 21e:	83 fb 01             	cmp    $0x1,%ebx
 221:	0f 84 b9 00 00 00    	je     2e0 <fib+0x1a0>
      return fib(n - 1) + fib(n - 2);
 227:	83 ec 0c             	sub    $0xc,%esp
 22a:	8d 43 ff             	lea    -0x1(%ebx),%eax
 22d:	89 55 bc             	mov    %edx,-0x44(%ebp)
 230:	50                   	push   %eax
 231:	e8 0a ff ff ff       	call   140 <fib>
 236:	83 c4 10             	add    $0x10,%esp
   if (n == 0) {
 239:	8b 55 bc             	mov    -0x44(%ebp),%edx
 23c:	01 c6                	add    %eax,%esi
 23e:	83 eb 02             	sub    $0x2,%ebx
 241:	75 db                	jne    21e <fib+0xde>
 243:	89 f9                	mov    %edi,%ecx
 245:	8b 7d c0             	mov    -0x40(%ebp),%edi
 248:	01 f2                	add    %esi,%edx
 24a:	83 ef 02             	sub    $0x2,%edi
 24d:	75 bc                	jne    20b <fib+0xcb>
 24f:	89 d7                	mov    %edx,%edi
 251:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 255:	01 f9                	add    %edi,%ecx
 257:	83 6d e0 02          	subl   $0x2,-0x20(%ebp)
 25b:	75 9b                	jne    1f8 <fib+0xb8>
 25d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
 260:	01 4d dc             	add    %ecx,-0x24(%ebp)
 263:	85 db                	test   %ebx,%ebx
 265:	0f 85 73 ff ff ff    	jne    1de <fib+0x9e>
 26b:	8b 75 dc             	mov    -0x24(%ebp),%esi
 26e:	01 75 c8             	add    %esi,-0x38(%ebp)
 271:	83 6d b0 02          	subl   $0x2,-0x50(%ebp)
 275:	0f 85 4b ff ff ff    	jne    1c6 <fib+0x86>
 27b:	8b 75 c8             	mov    -0x38(%ebp),%esi
 27e:	01 75 cc             	add    %esi,-0x34(%ebp)
 281:	83 6d ac 02          	subl   $0x2,-0x54(%ebp)
 285:	0f 85 22 ff ff ff    	jne    1ad <fib+0x6d>
 28b:	8b 75 cc             	mov    -0x34(%ebp),%esi
 28e:	01 75 d0             	add    %esi,-0x30(%ebp)
 291:	83 6d b4 02          	subl   $0x2,-0x4c(%ebp)
 295:	0f 85 f9 fe ff ff    	jne    194 <fib+0x54>
 29b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 29e:	01 75 d4             	add    %esi,-0x2c(%ebp)
 2a1:	83 6d b8 02          	subl   $0x2,-0x48(%ebp)
 2a5:	74 10                	je     2b7 <fib+0x177>
   } else if (n == 1) {
 2a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
 2aa:	83 f8 01             	cmp    $0x1,%eax
 2ad:	0f 85 d4 fe ff ff    	jne    187 <fib+0x47>
 2b3:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 2b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2ba:	01 45 08             	add    %eax,0x8(%ebp)
   if (n == 0) {
 2bd:	83 6d d8 02          	subl   $0x2,-0x28(%ebp)
 2c1:	74 0e                	je     2d1 <fib+0x191>
   } else if (n == 1) {
 2c3:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
 2c7:	0f 85 9e fe ff ff    	jne    16b <fib+0x2b>
 2cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
}
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d7:	5b                   	pop    %ebx
 2d8:	5e                   	pop    %esi
 2d9:	5f                   	pop    %edi
 2da:	5d                   	pop    %ebp
 2db:	c3                   	ret    
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e0:	89 f9                	mov    %edi,%ecx
 2e2:	83 c6 01             	add    $0x1,%esi
 2e5:	8b 7d c0             	mov    -0x40(%ebp),%edi
 2e8:	e9 5b ff ff ff       	jmp    248 <fib+0x108>
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
 2f0:	89 d7                	mov    %edx,%edi
 2f2:	83 c7 01             	add    $0x1,%edi
 2f5:	e9 57 ff ff ff       	jmp    251 <fib+0x111>
 2fa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 2fe:	e9 68 ff ff ff       	jmp    26b <fib+0x12b>
 303:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
 306:	83 c1 01             	add    $0x1,%ecx
 309:	e9 52 ff ff ff       	jmp    260 <fib+0x120>
 30e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 312:	e9 64 ff ff ff       	jmp    27b <fib+0x13b>
 317:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 31b:	8b 75 cc             	mov    -0x34(%ebp),%esi
 31e:	01 75 d0             	add    %esi,-0x30(%ebp)
   if (n == 0) {
 321:	83 6d b4 02          	subl   $0x2,-0x4c(%ebp)
 325:	0f 85 69 fe ff ff    	jne    194 <fib+0x54>
 32b:	e9 6b ff ff ff       	jmp    29b <fib+0x15b>
 330:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 334:	8b 75 d0             	mov    -0x30(%ebp),%esi
 337:	01 75 d4             	add    %esi,-0x2c(%ebp)
 33a:	83 6d b8 02          	subl   $0x2,-0x48(%ebp)
 33e:	0f 85 63 ff ff ff    	jne    2a7 <fib+0x167>
 344:	e9 6e ff ff ff       	jmp    2b7 <fib+0x177>
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <worker>:
}

void
worker(void *arg1, void *arg2) {
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 08             	sub    $0x8,%esp
   int tmp1 = *(int*)arg1;
   int tmp2 = *(int*)arg2;
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	8b 10                	mov    (%eax),%edx
   assert(tmp1 == 11);
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	83 38 0b             	cmpl   $0xb,(%eax)
 361:	75 75                	jne    3d8 <worker+0x88>
   assert(tmp2 == 22);
 363:	83 fa 16             	cmp    $0x16,%edx
 366:	75 2a                	jne    392 <worker+0x42>
   assert(global == 1);
 368:	83 3d 48 11 00 00 01 	cmpl   $0x1,0x1148
 36f:	0f 84 80 00 00 00    	je     3f5 <worker+0xa5>
 375:	6a 40                	push   $0x40
 377:	68 78 0c 00 00       	push   $0xc78
 37c:	68 82 0c 00 00       	push   $0xc82
 381:	6a 01                	push   $0x1
 383:	e8 c8 05 00 00       	call   950 <printf>
 388:	83 c4 0c             	add    $0xc,%esp
 38b:	68 c1 0c 00 00       	push   $0xcc1
 390:	eb 1b                	jmp    3ad <worker+0x5d>
   assert(tmp2 == 22);
 392:	6a 3f                	push   $0x3f
 394:	68 78 0c 00 00       	push   $0xc78
 399:	68 82 0c 00 00       	push   $0xc82
 39e:	6a 01                	push   $0x1
 3a0:	e8 ab 05 00 00       	call   950 <printf>
 3a5:	83 c4 0c             	add    $0xc,%esp
 3a8:	68 b6 0c 00 00       	push   $0xcb6
 3ad:	68 95 0c 00 00       	push   $0xc95
 3b2:	6a 01                	push   $0x1
 3b4:	e8 97 05 00 00       	call   950 <printf>
 3b9:	58                   	pop    %eax
 3ba:	5a                   	pop    %edx
 3bb:	68 a9 0c 00 00       	push   $0xca9
 3c0:	6a 01                	push   $0x1
 3c2:	e8 89 05 00 00       	call   950 <printf>
 3c7:	59                   	pop    %ecx
 3c8:	ff 35 4c 11 00 00    	push   0x114c
 3ce:	e8 40 04 00 00       	call   813 <kill>
 3d3:	e8 0b 04 00 00       	call   7e3 <exit>
   assert(tmp1 == 11);
 3d8:	6a 3e                	push   $0x3e
 3da:	68 78 0c 00 00       	push   $0xc78
 3df:	68 82 0c 00 00       	push   $0xc82
 3e4:	6a 01                	push   $0x1
 3e6:	e8 65 05 00 00       	call   950 <printf>
 3eb:	83 c4 0c             	add    $0xc,%esp
 3ee:	68 8a 0c 00 00       	push   $0xc8a
 3f3:	eb b8                	jmp    3ad <worker+0x5d>
   assert(fib(2) == 1);
 3f5:	83 ec 0c             	sub    $0xc,%esp
 3f8:	6a 02                	push   $0x2
 3fa:	e8 41 fd ff ff       	call   140 <fib>
 3ff:	83 c4 10             	add    $0x10,%esp
 402:	83 e8 01             	sub    $0x1,%eax
 405:	74 1d                	je     424 <worker+0xd4>
 407:	6a 41                	push   $0x41
 409:	68 78 0c 00 00       	push   $0xc78
 40e:	68 82 0c 00 00       	push   $0xc82
 413:	6a 01                	push   $0x1
 415:	e8 36 05 00 00       	call   950 <printf>
 41a:	83 c4 0c             	add    $0xc,%esp
 41d:	68 cd 0c 00 00       	push   $0xccd
 422:	eb 89                	jmp    3ad <worker+0x5d>
   assert(fib(3) == 2);
 424:	83 ec 0c             	sub    $0xc,%esp
 427:	6a 03                	push   $0x3
 429:	e8 12 fd ff ff       	call   140 <fib>
 42e:	83 c4 10             	add    $0x10,%esp
 431:	83 f8 02             	cmp    $0x2,%eax
 434:	74 20                	je     456 <worker+0x106>
 436:	6a 42                	push   $0x42
 438:	68 78 0c 00 00       	push   $0xc78
 43d:	68 82 0c 00 00       	push   $0xc82
 442:	6a 01                	push   $0x1
 444:	e8 07 05 00 00       	call   950 <printf>
 449:	83 c4 0c             	add    $0xc,%esp
 44c:	68 d9 0c 00 00       	push   $0xcd9
 451:	e9 57 ff ff ff       	jmp    3ad <worker+0x5d>
   assert(fib(9) == 34);
 456:	83 ec 0c             	sub    $0xc,%esp
 459:	6a 09                	push   $0x9
 45b:	e8 e0 fc ff ff       	call   140 <fib>
 460:	83 c4 10             	add    $0x10,%esp
 463:	83 f8 22             	cmp    $0x22,%eax
 466:	74 20                	je     488 <worker+0x138>
 468:	6a 43                	push   $0x43
 46a:	68 78 0c 00 00       	push   $0xc78
 46f:	68 82 0c 00 00       	push   $0xc82
 474:	6a 01                	push   $0x1
 476:	e8 d5 04 00 00       	call   950 <printf>
 47b:	83 c4 0c             	add    $0xc,%esp
 47e:	68 e5 0c 00 00       	push   $0xce5
 483:	e9 25 ff ff ff       	jmp    3ad <worker+0x5d>
   assert(fib(15) == 610);
 488:	83 ec 0c             	sub    $0xc,%esp
 48b:	6a 0f                	push   $0xf
 48d:	e8 ae fc ff ff       	call   140 <fib>
 492:	83 c4 10             	add    $0x10,%esp
 495:	3d 62 02 00 00       	cmp    $0x262,%eax
 49a:	74 20                	je     4bc <worker+0x16c>
 49c:	6a 44                	push   $0x44
 49e:	68 78 0c 00 00       	push   $0xc78
 4a3:	68 82 0c 00 00       	push   $0xc82
 4a8:	6a 01                	push   $0x1
 4aa:	e8 a1 04 00 00       	call   950 <printf>
 4af:	83 c4 0c             	add    $0xc,%esp
 4b2:	68 f2 0c 00 00       	push   $0xcf2
 4b7:	e9 f1 fe ff ff       	jmp    3ad <worker+0x5d>
   exit();
 4bc:	e8 22 03 00 00       	call   7e3 <exit>
 4c1:	66 90                	xchg   %ax,%ax
 4c3:	66 90                	xchg   %ax,%ax
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	66 90                	xchg   %ax,%ax
 4c9:	66 90                	xchg   %ax,%ax
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <strcpy>:
    return val;
}

char*
strcpy(char *s, const char *t)
{
 4d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4d1:	31 c0                	xor    %eax,%eax
{
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	53                   	push   %ebx
 4d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 4e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 4e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 4e7:	83 c0 01             	add    $0x1,%eax
 4ea:	84 d2                	test   %dl,%dl
 4ec:	75 f2                	jne    4e0 <strcpy+0x10>
    ;
  return os;
}
 4ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f1:	89 c8                	mov    %ecx,%eax
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    
 4f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	8b 55 08             	mov    0x8(%ebp),%edx
 507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 50a:	0f b6 02             	movzbl (%edx),%eax
 50d:	84 c0                	test   %al,%al
 50f:	75 17                	jne    528 <strcmp+0x28>
 511:	eb 3a                	jmp    54d <strcmp+0x4d>
 513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 517:	90                   	nop
 518:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 51c:	83 c2 01             	add    $0x1,%edx
 51f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 522:	84 c0                	test   %al,%al
 524:	74 1a                	je     540 <strcmp+0x40>
    p++, q++;
 526:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 528:	0f b6 19             	movzbl (%ecx),%ebx
 52b:	38 c3                	cmp    %al,%bl
 52d:	74 e9                	je     518 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 52f:	29 d8                	sub    %ebx,%eax
}
 531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 534:	c9                   	leave  
 535:	c3                   	ret    
 536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 540:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 544:	31 c0                	xor    %eax,%eax
 546:	29 d8                	sub    %ebx,%eax
}
 548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 54b:	c9                   	leave  
 54c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 54d:	0f b6 19             	movzbl (%ecx),%ebx
 550:	31 c0                	xor    %eax,%eax
 552:	eb db                	jmp    52f <strcmp+0x2f>
 554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop

00000560 <strlen>:

uint
strlen(const char *s)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 566:	80 3a 00             	cmpb   $0x0,(%edx)
 569:	74 15                	je     580 <strlen+0x20>
 56b:	31 c0                	xor    %eax,%eax
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	83 c0 01             	add    $0x1,%eax
 573:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 577:	89 c1                	mov    %eax,%ecx
 579:	75 f5                	jne    570 <strlen+0x10>
    ;
  return n;
}
 57b:	89 c8                	mov    %ecx,%eax
 57d:	5d                   	pop    %ebp
 57e:	c3                   	ret    
 57f:	90                   	nop
  for(n = 0; s[n]; n++)
 580:	31 c9                	xor    %ecx,%ecx
}
 582:	5d                   	pop    %ebp
 583:	89 c8                	mov    %ecx,%eax
 585:	c3                   	ret    
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi

00000590 <memset>:

void*
memset(void *dst, int c, uint n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 597:	8b 4d 10             	mov    0x10(%ebp),%ecx
 59a:	8b 45 0c             	mov    0xc(%ebp),%eax
 59d:	89 d7                	mov    %edx,%edi
 59f:	fc                   	cld    
 5a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 5a5:	89 d0                	mov    %edx,%eax
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005b0 <strchr>:

char*
strchr(const char *s, char c)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5ba:	0f b6 10             	movzbl (%eax),%edx
 5bd:	84 d2                	test   %dl,%dl
 5bf:	75 12                	jne    5d3 <strchr+0x23>
 5c1:	eb 1d                	jmp    5e0 <strchr+0x30>
 5c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c7:	90                   	nop
 5c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5cc:	83 c0 01             	add    $0x1,%eax
 5cf:	84 d2                	test   %dl,%dl
 5d1:	74 0d                	je     5e0 <strchr+0x30>
    if(*s == c)
 5d3:	38 d1                	cmp    %dl,%cl
 5d5:	75 f1                	jne    5c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret    
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 5e0:	31 c0                	xor    %eax,%eax
}
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 5f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 5f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 5f9:	31 db                	xor    %ebx,%ebx
{
 5fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 5fe:	eb 27                	jmp    627 <gets+0x37>
    cc = read(0, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
 603:	6a 01                	push   $0x1
 605:	57                   	push   %edi
 606:	6a 00                	push   $0x0
 608:	e8 ee 01 00 00       	call   7fb <read>
    if(cc < 1)
 60d:	83 c4 10             	add    $0x10,%esp
 610:	85 c0                	test   %eax,%eax
 612:	7e 1d                	jle    631 <gets+0x41>
      break;
    buf[i++] = c;
 614:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 618:	8b 55 08             	mov    0x8(%ebp),%edx
 61b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 61f:	3c 0a                	cmp    $0xa,%al
 621:	74 1d                	je     640 <gets+0x50>
 623:	3c 0d                	cmp    $0xd,%al
 625:	74 19                	je     640 <gets+0x50>
  for(i=0; i+1 < max; ){
 627:	89 de                	mov    %ebx,%esi
 629:	83 c3 01             	add    $0x1,%ebx
 62c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 62f:	7c cf                	jl     600 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 638:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63b:	5b                   	pop    %ebx
 63c:	5e                   	pop    %esi
 63d:	5f                   	pop    %edi
 63e:	5d                   	pop    %ebp
 63f:	c3                   	ret    
  buf[i] = '\0';
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 de                	mov    %ebx,%esi
 645:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 649:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64c:	5b                   	pop    %ebx
 64d:	5e                   	pop    %esi
 64e:	5f                   	pop    %edi
 64f:	5d                   	pop    %ebp
 650:	c3                   	ret    
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop

00000660 <stat>:

int
stat(const char *n, struct stat *st)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	56                   	push   %esi
 664:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 665:	83 ec 08             	sub    $0x8,%esp
 668:	6a 00                	push   $0x0
 66a:	ff 75 08             	push   0x8(%ebp)
 66d:	e8 b1 01 00 00       	call   823 <open>
  if(fd < 0)
 672:	83 c4 10             	add    $0x10,%esp
 675:	85 c0                	test   %eax,%eax
 677:	78 27                	js     6a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	ff 75 0c             	push   0xc(%ebp)
 67f:	89 c3                	mov    %eax,%ebx
 681:	50                   	push   %eax
 682:	e8 b4 01 00 00       	call   83b <fstat>
  close(fd);
 687:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 68a:	89 c6                	mov    %eax,%esi
  close(fd);
 68c:	e8 7a 01 00 00       	call   80b <close>
  return r;
 691:	83 c4 10             	add    $0x10,%esp
}
 694:	8d 65 f8             	lea    -0x8(%ebp),%esp
 697:	89 f0                	mov    %esi,%eax
 699:	5b                   	pop    %ebx
 69a:	5e                   	pop    %esi
 69b:	5d                   	pop    %ebp
 69c:	c3                   	ret    
 69d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6a5:	eb ed                	jmp    694 <stat+0x34>
 6a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <atoi>:

int
atoi(const char *s)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	53                   	push   %ebx
 6b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6b7:	0f be 02             	movsbl (%edx),%eax
 6ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6c5:	77 1e                	ja     6e5 <atoi+0x35>
 6c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 6d0:	83 c2 01             	add    $0x1,%edx
 6d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 6d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 6da:	0f be 02             	movsbl (%edx),%eax
 6dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 6e0:	80 fb 09             	cmp    $0x9,%bl
 6e3:	76 eb                	jbe    6d0 <atoi+0x20>
  return n;
}
 6e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e8:	89 c8                	mov    %ecx,%eax
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	8b 45 10             	mov    0x10(%ebp),%eax
 6f7:	8b 55 08             	mov    0x8(%ebp),%edx
 6fa:	56                   	push   %esi
 6fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6fe:	85 c0                	test   %eax,%eax
 700:	7e 13                	jle    715 <memmove+0x25>
 702:	01 d0                	add    %edx,%eax
  dst = vdst;
 704:	89 d7                	mov    %edx,%edi
 706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 710:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 711:	39 f8                	cmp    %edi,%eax
 713:	75 fb                	jne    710 <memmove+0x20>
  return vdst;
}
 715:	5e                   	pop    %esi
 716:	89 d0                	mov    %edx,%eax
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop

00000720 <thread_create>:

int 
thread_create(void (*start_routine)(void *, void *), void* arg1, void* arg2)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 14             	sub    $0x14,%esp
  void* stack;
  stack = malloc(PGSIZE);
 726:	68 00 10 00 00       	push   $0x1000
 72b:	e8 50 04 00 00       	call   b80 <malloc>
  // printf(1 , "%d" , stack);
  return clone(start_routine, arg1, arg2, stack);
 730:	50                   	push   %eax
 731:	ff 75 10             	push   0x10(%ebp)
 734:	ff 75 0c             	push   0xc(%ebp)
 737:	ff 75 08             	push   0x8(%ebp)
 73a:	e8 44 01 00 00       	call   883 <clone>
}
 73f:	c9                   	leave  
 740:	c3                   	ret    
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop

00000750 <thread_join>:

int 
thread_join() 
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	83 ec 34             	sub    $0x34,%esp
  void *stack;
  int ret_pid = join(&stack);
 756:	8d 45 f4             	lea    -0xc(%ebp),%eax
 759:	50                   	push   %eax
 75a:	e8 2c 01 00 00       	call   88b <join>

  if (ret_pid != -1) 
 75f:	83 c4 10             	add    $0x10,%esp
 762:	83 f8 ff             	cmp    $0xffffffff,%eax
 765:	75 09                	jne    770 <thread_join+0x20>
    free(stack);
  }

  return ret_pid;

}
 767:	c9                   	leave  
 768:	c3                   	ret    
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    free(stack);
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	ff 75 f4             	push   -0xc(%ebp)
 776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 779:	e8 72 03 00 00       	call   af0 <free>
 77e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 781:	83 c4 10             	add    $0x10,%esp
}
 784:	c9                   	leave  
 785:	c3                   	ret    
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi

00000790 <lock_init>:

void lock_init(lock_t *lock)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->ticket = 0;
 796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  lock->turn = 0;
 79d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 7a3:	5d                   	pop    %ebp
 7a4:	c3                   	ret    
 7a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <lock_acquire>:

void lock_acquire(lock_t *lock){
 7b0:	55                   	push   %ebp
    __asm__ volatile
 7b1:	b8 01 00 00 00       	mov    $0x1,%eax
void lock_acquire(lock_t *lock){
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	8b 55 08             	mov    0x8(%ebp),%edx
    __asm__ volatile
 7bb:	f0 0f c1 42 04       	lock xadd %eax,0x4(%edx)
  int myTurn = fetch_and_add(&lock->ticket , 1);
  while ( lock->turn != myTurn) 
 7c0:	8b 12                	mov    (%edx),%edx
 7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7c8:	39 c2                	cmp    %eax,%edx
 7ca:	75 fc                	jne    7c8 <lock_acquire+0x18>
  {}; // keep spinning
}
 7cc:	5d                   	pop    %ebp
 7cd:	c3                   	ret    
 7ce:	66 90                	xchg   %ax,%ax

000007d0 <lock_release>:

void lock_release(lock_t *lock){
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
	lock->turn += 1;
 7d6:	83 00 01             	addl   $0x1,(%eax)
}
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    

000007db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7db:	b8 01 00 00 00       	mov    $0x1,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <exit>:
SYSCALL(exit)
 7e3:	b8 02 00 00 00       	mov    $0x2,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <wait>:
SYSCALL(wait)
 7eb:	b8 03 00 00 00       	mov    $0x3,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <pipe>:
SYSCALL(pipe)
 7f3:	b8 04 00 00 00       	mov    $0x4,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <read>:
SYSCALL(read)
 7fb:	b8 05 00 00 00       	mov    $0x5,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <write>:
SYSCALL(write)
 803:	b8 10 00 00 00       	mov    $0x10,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <close>:
SYSCALL(close)
 80b:	b8 15 00 00 00       	mov    $0x15,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <kill>:
SYSCALL(kill)
 813:	b8 06 00 00 00       	mov    $0x6,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <exec>:
SYSCALL(exec)
 81b:	b8 07 00 00 00       	mov    $0x7,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <open>:
SYSCALL(open)
 823:	b8 0f 00 00 00       	mov    $0xf,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <mknod>:
SYSCALL(mknod)
 82b:	b8 11 00 00 00       	mov    $0x11,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <unlink>:
SYSCALL(unlink)
 833:	b8 12 00 00 00       	mov    $0x12,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <fstat>:
SYSCALL(fstat)
 83b:	b8 08 00 00 00       	mov    $0x8,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <link>:
SYSCALL(link)
 843:	b8 13 00 00 00       	mov    $0x13,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <mkdir>:
SYSCALL(mkdir)
 84b:	b8 14 00 00 00       	mov    $0x14,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <chdir>:
SYSCALL(chdir)
 853:	b8 09 00 00 00       	mov    $0x9,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <dup>:
SYSCALL(dup)
 85b:	b8 0a 00 00 00       	mov    $0xa,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <getpid>:
SYSCALL(getpid)
 863:	b8 0b 00 00 00       	mov    $0xb,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <sbrk>:
SYSCALL(sbrk)
 86b:	b8 0c 00 00 00       	mov    $0xc,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <sleep>:
SYSCALL(sleep)
 873:	b8 0d 00 00 00       	mov    $0xd,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    

0000087b <uptime>:
SYSCALL(uptime)
 87b:	b8 0e 00 00 00       	mov    $0xe,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret    

00000883 <clone>:
SYSCALL(clone)
 883:	b8 16 00 00 00       	mov    $0x16,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret    

0000088b <join>:
 88b:	b8 17 00 00 00       	mov    $0x17,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret    
 893:	66 90                	xchg   %ax,%ax
 895:	66 90                	xchg   %ax,%ax
 897:	66 90                	xchg   %ax,%ax
 899:	66 90                	xchg   %ax,%ax
 89b:	66 90                	xchg   %ax,%ax
 89d:	66 90                	xchg   %ax,%ax
 89f:	90                   	nop

000008a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 3c             	sub    $0x3c,%esp
 8a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 8ac:	89 d1                	mov    %edx,%ecx
{
 8ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 8b1:	85 d2                	test   %edx,%edx
 8b3:	0f 89 7f 00 00 00    	jns    938 <printint+0x98>
 8b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 8bd:	74 79                	je     938 <printint+0x98>
    neg = 1;
 8bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 8c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 8c8:	31 db                	xor    %ebx,%ebx
 8ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 8cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 8d0:	89 c8                	mov    %ecx,%eax
 8d2:	31 d2                	xor    %edx,%edx
 8d4:	89 cf                	mov    %ecx,%edi
 8d6:	f7 75 c4             	divl   -0x3c(%ebp)
 8d9:	0f b6 92 9c 0d 00 00 	movzbl 0xd9c(%edx),%edx
 8e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 8e3:	89 d8                	mov    %ebx,%eax
 8e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 8e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 8eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 8ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 8f1:	76 dd                	jbe    8d0 <printint+0x30>
  if(neg)
 8f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 8f6:	85 c9                	test   %ecx,%ecx
 8f8:	74 0c                	je     906 <printint+0x66>
    buf[i++] = '-';
 8fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 8ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 901:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 906:	8b 7d b8             	mov    -0x48(%ebp),%edi
 909:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 90d:	eb 07                	jmp    916 <printint+0x76>
 90f:	90                   	nop
    putc(fd, buf[i]);
 910:	0f b6 13             	movzbl (%ebx),%edx
 913:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 916:	83 ec 04             	sub    $0x4,%esp
 919:	88 55 d7             	mov    %dl,-0x29(%ebp)
 91c:	6a 01                	push   $0x1
 91e:	56                   	push   %esi
 91f:	57                   	push   %edi
 920:	e8 de fe ff ff       	call   803 <write>
  while(--i >= 0)
 925:	83 c4 10             	add    $0x10,%esp
 928:	39 de                	cmp    %ebx,%esi
 92a:	75 e4                	jne    910 <printint+0x70>
}
 92c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 92f:	5b                   	pop    %ebx
 930:	5e                   	pop    %esi
 931:	5f                   	pop    %edi
 932:	5d                   	pop    %ebp
 933:	c3                   	ret    
 934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 938:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 93f:	eb 87                	jmp    8c8 <printint+0x28>
 941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 94f:	90                   	nop

00000950 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 959:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 95c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 95f:	0f b6 13             	movzbl (%ebx),%edx
 962:	84 d2                	test   %dl,%dl
 964:	74 6a                	je     9d0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 966:	8d 45 10             	lea    0x10(%ebp),%eax
 969:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 96c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 96f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 971:	89 45 d0             	mov    %eax,-0x30(%ebp)
 974:	eb 36                	jmp    9ac <printf+0x5c>
 976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97d:	8d 76 00             	lea    0x0(%esi),%esi
 980:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 983:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 988:	83 f8 25             	cmp    $0x25,%eax
 98b:	74 15                	je     9a2 <printf+0x52>
  write(fd, &c, 1);
 98d:	83 ec 04             	sub    $0x4,%esp
 990:	88 55 e7             	mov    %dl,-0x19(%ebp)
 993:	6a 01                	push   $0x1
 995:	57                   	push   %edi
 996:	56                   	push   %esi
 997:	e8 67 fe ff ff       	call   803 <write>
 99c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 99f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9a2:	0f b6 13             	movzbl (%ebx),%edx
 9a5:	83 c3 01             	add    $0x1,%ebx
 9a8:	84 d2                	test   %dl,%dl
 9aa:	74 24                	je     9d0 <printf+0x80>
    c = fmt[i] & 0xff;
 9ac:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 9af:	85 c9                	test   %ecx,%ecx
 9b1:	74 cd                	je     980 <printf+0x30>
      }
    } else if(state == '%'){
 9b3:	83 f9 25             	cmp    $0x25,%ecx
 9b6:	75 ea                	jne    9a2 <printf+0x52>
      if(c == 'd'){
 9b8:	83 f8 25             	cmp    $0x25,%eax
 9bb:	0f 84 07 01 00 00    	je     ac8 <printf+0x178>
 9c1:	83 e8 63             	sub    $0x63,%eax
 9c4:	83 f8 15             	cmp    $0x15,%eax
 9c7:	77 17                	ja     9e0 <printf+0x90>
 9c9:	ff 24 85 44 0d 00 00 	jmp    *0xd44(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	c3                   	ret    
 9d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9df:	90                   	nop
  write(fd, &c, 1);
 9e0:	83 ec 04             	sub    $0x4,%esp
 9e3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 9e6:	6a 01                	push   $0x1
 9e8:	57                   	push   %edi
 9e9:	56                   	push   %esi
 9ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9ee:	e8 10 fe ff ff       	call   803 <write>
        putc(fd, c);
 9f3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 9f7:	83 c4 0c             	add    $0xc,%esp
 9fa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 9fd:	6a 01                	push   $0x1
 9ff:	57                   	push   %edi
 a00:	56                   	push   %esi
 a01:	e8 fd fd ff ff       	call   803 <write>
        putc(fd, c);
 a06:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a09:	31 c9                	xor    %ecx,%ecx
 a0b:	eb 95                	jmp    9a2 <printf+0x52>
 a0d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 10 00 00 00       	mov    $0x10,%ecx
 a18:	6a 00                	push   $0x0
 a1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a1d:	8b 10                	mov    (%eax),%edx
 a1f:	89 f0                	mov    %esi,%eax
 a21:	e8 7a fe ff ff       	call   8a0 <printint>
        ap++;
 a26:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 a2a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a2d:	31 c9                	xor    %ecx,%ecx
 a2f:	e9 6e ff ff ff       	jmp    9a2 <printf+0x52>
 a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 a38:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a3b:	8b 10                	mov    (%eax),%edx
        ap++;
 a3d:	83 c0 04             	add    $0x4,%eax
 a40:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a43:	85 d2                	test   %edx,%edx
 a45:	0f 84 8d 00 00 00    	je     ad8 <printf+0x188>
        while(*s != 0){
 a4b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 a4e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 a50:	84 c0                	test   %al,%al
 a52:	0f 84 4a ff ff ff    	je     9a2 <printf+0x52>
 a58:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a5b:	89 d3                	mov    %edx,%ebx
 a5d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 a60:	83 ec 04             	sub    $0x4,%esp
          s++;
 a63:	83 c3 01             	add    $0x1,%ebx
 a66:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a69:	6a 01                	push   $0x1
 a6b:	57                   	push   %edi
 a6c:	56                   	push   %esi
 a6d:	e8 91 fd ff ff       	call   803 <write>
        while(*s != 0){
 a72:	0f b6 03             	movzbl (%ebx),%eax
 a75:	83 c4 10             	add    $0x10,%esp
 a78:	84 c0                	test   %al,%al
 a7a:	75 e4                	jne    a60 <printf+0x110>
      state = 0;
 a7c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 a7f:	31 c9                	xor    %ecx,%ecx
 a81:	e9 1c ff ff ff       	jmp    9a2 <printf+0x52>
 a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 a90:	83 ec 0c             	sub    $0xc,%esp
 a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a98:	6a 01                	push   $0x1
 a9a:	e9 7b ff ff ff       	jmp    a1a <printf+0xca>
 a9f:	90                   	nop
        putc(fd, *ap);
 aa0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 aa3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 aa6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 aa8:	6a 01                	push   $0x1
 aaa:	57                   	push   %edi
 aab:	56                   	push   %esi
        putc(fd, *ap);
 aac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 aaf:	e8 4f fd ff ff       	call   803 <write>
        ap++;
 ab4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 ab8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 abb:	31 c9                	xor    %ecx,%ecx
 abd:	e9 e0 fe ff ff       	jmp    9a2 <printf+0x52>
 ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 ac8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 acb:	83 ec 04             	sub    $0x4,%esp
 ace:	e9 2a ff ff ff       	jmp    9fd <printf+0xad>
 ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 ad7:	90                   	nop
          s = "(null)";
 ad8:	ba 3c 0d 00 00       	mov    $0xd3c,%edx
        while(*s != 0){
 add:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 ae0:	b8 28 00 00 00       	mov    $0x28,%eax
 ae5:	89 d3                	mov    %edx,%ebx
 ae7:	e9 74 ff ff ff       	jmp    a60 <printf+0x110>
 aec:	66 90                	xchg   %ax,%ax
 aee:	66 90                	xchg   %ax,%ax

00000af0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af1:	a1 50 11 00 00       	mov    0x1150,%eax
{
 af6:	89 e5                	mov    %esp,%ebp
 af8:	57                   	push   %edi
 af9:	56                   	push   %esi
 afa:	53                   	push   %ebx
 afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 afe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b08:	89 c2                	mov    %eax,%edx
 b0a:	8b 00                	mov    (%eax),%eax
 b0c:	39 ca                	cmp    %ecx,%edx
 b0e:	73 30                	jae    b40 <free+0x50>
 b10:	39 c1                	cmp    %eax,%ecx
 b12:	72 04                	jb     b18 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b14:	39 c2                	cmp    %eax,%edx
 b16:	72 f0                	jb     b08 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b18:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b1b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b1e:	39 f8                	cmp    %edi,%eax
 b20:	74 30                	je     b52 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b22:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b25:	8b 42 04             	mov    0x4(%edx),%eax
 b28:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 b2b:	39 f1                	cmp    %esi,%ecx
 b2d:	74 3a                	je     b69 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b2f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b31:	5b                   	pop    %ebx
  freep = p;
 b32:	89 15 50 11 00 00    	mov    %edx,0x1150
}
 b38:	5e                   	pop    %esi
 b39:	5f                   	pop    %edi
 b3a:	5d                   	pop    %ebp
 b3b:	c3                   	ret    
 b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b40:	39 c2                	cmp    %eax,%edx
 b42:	72 c4                	jb     b08 <free+0x18>
 b44:	39 c1                	cmp    %eax,%ecx
 b46:	73 c0                	jae    b08 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 b48:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b4b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b4e:	39 f8                	cmp    %edi,%eax
 b50:	75 d0                	jne    b22 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 b52:	03 70 04             	add    0x4(%eax),%esi
 b55:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b58:	8b 02                	mov    (%edx),%eax
 b5a:	8b 00                	mov    (%eax),%eax
 b5c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 b5f:	8b 42 04             	mov    0x4(%edx),%eax
 b62:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 b65:	39 f1                	cmp    %esi,%ecx
 b67:	75 c6                	jne    b2f <free+0x3f>
    p->s.size += bp->s.size;
 b69:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 b6c:	89 15 50 11 00 00    	mov    %edx,0x1150
    p->s.size += bp->s.size;
 b72:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 b75:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 b78:	89 0a                	mov    %ecx,(%edx)
}
 b7a:	5b                   	pop    %ebx
 b7b:	5e                   	pop    %esi
 b7c:	5f                   	pop    %edi
 b7d:	5d                   	pop    %ebp
 b7e:	c3                   	ret    
 b7f:	90                   	nop

00000b80 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b80:	55                   	push   %ebp
 b81:	89 e5                	mov    %esp,%ebp
 b83:	57                   	push   %edi
 b84:	56                   	push   %esi
 b85:	53                   	push   %ebx
 b86:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b89:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b8c:	8b 3d 50 11 00 00    	mov    0x1150,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b92:	8d 70 07             	lea    0x7(%eax),%esi
 b95:	c1 ee 03             	shr    $0x3,%esi
 b98:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b9b:	85 ff                	test   %edi,%edi
 b9d:	0f 84 9d 00 00 00    	je     c40 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 ba5:	8b 4a 04             	mov    0x4(%edx),%ecx
 ba8:	39 f1                	cmp    %esi,%ecx
 baa:	73 6a                	jae    c16 <malloc+0x96>
 bac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 bb1:	39 de                	cmp    %ebx,%esi
 bb3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 bb6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 bbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 bc0:	eb 17                	jmp    bd9 <malloc+0x59>
 bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 bca:	8b 48 04             	mov    0x4(%eax),%ecx
 bcd:	39 f1                	cmp    %esi,%ecx
 bcf:	73 4f                	jae    c20 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd1:	8b 3d 50 11 00 00    	mov    0x1150,%edi
 bd7:	89 c2                	mov    %eax,%edx
 bd9:	39 d7                	cmp    %edx,%edi
 bdb:	75 eb                	jne    bc8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 bdd:	83 ec 0c             	sub    $0xc,%esp
 be0:	ff 75 e4             	push   -0x1c(%ebp)
 be3:	e8 83 fc ff ff       	call   86b <sbrk>
  if(p == (char*)-1)
 be8:	83 c4 10             	add    $0x10,%esp
 beb:	83 f8 ff             	cmp    $0xffffffff,%eax
 bee:	74 1c                	je     c0c <malloc+0x8c>
  hp->s.size = nu;
 bf0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bf3:	83 ec 0c             	sub    $0xc,%esp
 bf6:	83 c0 08             	add    $0x8,%eax
 bf9:	50                   	push   %eax
 bfa:	e8 f1 fe ff ff       	call   af0 <free>
  return freep;
 bff:	8b 15 50 11 00 00    	mov    0x1150,%edx
      if((p = morecore(nunits)) == 0)
 c05:	83 c4 10             	add    $0x10,%esp
 c08:	85 d2                	test   %edx,%edx
 c0a:	75 bc                	jne    bc8 <malloc+0x48>
        return 0;
  }
}
 c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c0f:	31 c0                	xor    %eax,%eax
}
 c11:	5b                   	pop    %ebx
 c12:	5e                   	pop    %esi
 c13:	5f                   	pop    %edi
 c14:	5d                   	pop    %ebp
 c15:	c3                   	ret    
    if(p->s.size >= nunits){
 c16:	89 d0                	mov    %edx,%eax
 c18:	89 fa                	mov    %edi,%edx
 c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 c20:	39 ce                	cmp    %ecx,%esi
 c22:	74 4c                	je     c70 <malloc+0xf0>
        p->s.size -= nunits;
 c24:	29 f1                	sub    %esi,%ecx
 c26:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 c29:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 c2c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 c2f:	89 15 50 11 00 00    	mov    %edx,0x1150
}
 c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c38:	83 c0 08             	add    $0x8,%eax
}
 c3b:	5b                   	pop    %ebx
 c3c:	5e                   	pop    %esi
 c3d:	5f                   	pop    %edi
 c3e:	5d                   	pop    %ebp
 c3f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 c40:	c7 05 50 11 00 00 54 	movl   $0x1154,0x1150
 c47:	11 00 00 
    base.s.size = 0;
 c4a:	bf 54 11 00 00       	mov    $0x1154,%edi
    base.s.ptr = freep = prevp = &base;
 c4f:	c7 05 54 11 00 00 54 	movl   $0x1154,0x1154
 c56:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c59:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 c5b:	c7 05 58 11 00 00 00 	movl   $0x0,0x1158
 c62:	00 00 00 
    if(p->s.size >= nunits){
 c65:	e9 42 ff ff ff       	jmp    bac <malloc+0x2c>
 c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c70:	8b 08                	mov    (%eax),%ecx
 c72:	89 0a                	mov    %ecx,(%edx)
 c74:	eb b9                	jmp    c2f <malloc+0xaf>
