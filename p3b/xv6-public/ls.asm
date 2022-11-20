
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  10:	bb 01 00 00 00       	mov    $0x1,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  27:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	push   (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
  exit();
  3d:	e8 11 06 00 00       	call   653 <exit>
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 30 0b 00 00       	push   $0xb30
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 ff 05 00 00       	call   653 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	56                   	push   %esi
  6c:	e8 5f 03 00 00       	call   3d0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 f0                	add    %esi,%eax
  76:	89 c3                	mov    %eax,%ebx
  78:	73 0f                	jae    89 <fmtname+0x29>
  7a:	eb 12                	jmp    8e <fmtname+0x2e>
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  83:	39 c6                	cmp    %eax,%esi
  85:	77 0a                	ja     91 <fmtname+0x31>
  87:	89 c3                	mov    %eax,%ebx
  89:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8c:	75 f2                	jne    80 <fmtname+0x20>
  p++;
  8e:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	53                   	push   %ebx
  95:	e8 36 03 00 00       	call   3d0 <strlen>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	83 f8 0d             	cmp    $0xd,%eax
  a0:	77 4a                	ja     ec <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  a2:	83 ec 0c             	sub    $0xc,%esp
  a5:	53                   	push   %ebx
  a6:	e8 25 03 00 00       	call   3d0 <strlen>
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	50                   	push   %eax
  af:	53                   	push   %ebx
  b0:	68 6c 0f 00 00       	push   $0xf6c
  b5:	e8 a6 04 00 00       	call   560 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 0e 03 00 00       	call   3d0 <strlen>
  c2:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  c5:	bb 6c 0f 00 00       	mov    $0xf6c,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	89 c6                	mov    %eax,%esi
  cc:	e8 ff 02 00 00       	call   3d0 <strlen>
  d1:	ba 0e 00 00 00       	mov    $0xe,%edx
  d6:	83 c4 0c             	add    $0xc,%esp
  d9:	29 f2                	sub    %esi,%edx
  db:	05 6c 0f 00 00       	add    $0xf6c,%eax
  e0:	52                   	push   %edx
  e1:	6a 20                	push   $0x20
  e3:	50                   	push   %eax
  e4:	e8 17 03 00 00       	call   400 <memset>
  return buf;
  e9:	83 c4 10             	add    $0x10,%esp
}
  ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ef:	89 d8                	mov    %ebx,%eax
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 7c 05 00 00       	call   693 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 9e 01 00 00    	js     2c0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 122:	83 ec 08             	sub    $0x8,%esp
 125:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 77 05 00 00       	call   6ab <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 c1 01 00 00    	js     300 <ls+0x200>
  switch(st.type){
 13f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	74 64                	je     1b0 <ls+0xb0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	74 1e                	je     170 <ls+0x70>
  close(fd);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	53                   	push   %ebx
 156:	e8 20 05 00 00       	call   67b <close>
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 170:	83 ec 0c             	sub    $0xc,%esp
 173:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 179:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 17f:	57                   	push   %edi
 180:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 186:	e8 d5 fe ff ff       	call   60 <fmtname>
 18b:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 191:	59                   	pop    %ecx
 192:	5f                   	pop    %edi
 193:	52                   	push   %edx
 194:	56                   	push   %esi
 195:	6a 02                	push   $0x2
 197:	50                   	push   %eax
 198:	68 10 0b 00 00       	push   $0xb10
 19d:	6a 01                	push   $0x1
 19f:	e8 1c 06 00 00       	call   7c0 <printf>
    break;
 1a4:	83 c4 20             	add    $0x20,%esp
 1a7:	eb a9                	jmp    152 <ls+0x52>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1b0:	83 ec 0c             	sub    $0xc,%esp
 1b3:	57                   	push   %edi
 1b4:	e8 17 02 00 00       	call   3d0 <strlen>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	83 c0 10             	add    $0x10,%eax
 1bf:	3d 00 02 00 00       	cmp    $0x200,%eax
 1c4:	0f 87 16 01 00 00    	ja     2e0 <ls+0x1e0>
    strcpy(buf, path);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	57                   	push   %edi
 1ce:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1d4:	57                   	push   %edi
 1d5:	e8 66 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1da:	89 3c 24             	mov    %edi,(%esp)
 1dd:	e8 ee 01 00 00       	call   3d0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1e5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1e7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1ea:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 1f0:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 1f6:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	83 ec 04             	sub    $0x4,%esp
 203:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 209:	6a 10                	push   $0x10
 20b:	50                   	push   %eax
 20c:	53                   	push   %ebx
 20d:	e8 59 04 00 00       	call   66b <read>
 212:	83 c4 10             	add    $0x10,%esp
 215:	83 f8 10             	cmp    $0x10,%eax
 218:	0f 85 34 ff ff ff    	jne    152 <ls+0x52>
      if(de.inum == 0)
 21e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 225:	00 
 226:	74 d8                	je     200 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 231:	6a 0e                	push   $0xe
 233:	50                   	push   %eax
 234:	ff b5 a4 fd ff ff    	push   -0x25c(%ebp)
 23a:	e8 21 03 00 00       	call   560 <memmove>
      p[DIRSIZ] = 0;
 23f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 245:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 249:	58                   	pop    %eax
 24a:	5a                   	pop    %edx
 24b:	56                   	push   %esi
 24c:	57                   	push   %edi
 24d:	e8 7e 02 00 00       	call   4d0 <stat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	0f 88 cb 00 00 00    	js     328 <ls+0x228>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25d:	83 ec 0c             	sub    $0xc,%esp
 260:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 266:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 26c:	57                   	push   %edi
 26d:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 274:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 27a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 280:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 286:	e8 d5 fd ff ff       	call   60 <fmtname>
 28b:	5a                   	pop    %edx
 28c:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 292:	59                   	pop    %ecx
 293:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 299:	51                   	push   %ecx
 29a:	52                   	push   %edx
 29b:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 2a1:	50                   	push   %eax
 2a2:	68 10 0b 00 00       	push   $0xb10
 2a7:	6a 01                	push   $0x1
 2a9:	e8 12 05 00 00       	call   7c0 <printf>
 2ae:	83 c4 20             	add    $0x20,%esp
 2b1:	e9 4a ff ff ff       	jmp    200 <ls+0x100>
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	57                   	push   %edi
 2c4:	68 e8 0a 00 00       	push   $0xae8
 2c9:	6a 02                	push   $0x2
 2cb:	e8 f0 04 00 00       	call   7c0 <printf>
    return;
 2d0:	83 c4 10             	add    $0x10,%esp
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop
      printf(1, "ls: path too long\n");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 1d 0b 00 00       	push   $0xb1d
 2e8:	6a 01                	push   $0x1
 2ea:	e8 d1 04 00 00       	call   7c0 <printf>
      break;
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	e9 5b fe ff ff       	jmp    152 <ls+0x52>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	57                   	push   %edi
 304:	68 fc 0a 00 00       	push   $0xafc
 309:	6a 02                	push   $0x2
 30b:	e8 b0 04 00 00       	call   7c0 <printf>
    close(fd);
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	e8 63 03 00 00       	call   67b <close>
    return;
 318:	83 c4 10             	add    $0x10,%esp
}
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 327:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 328:	83 ec 04             	sub    $0x4,%esp
 32b:	57                   	push   %edi
 32c:	68 fc 0a 00 00       	push   $0xafc
 331:	6a 01                	push   $0x1
 333:	e8 88 04 00 00       	call   7c0 <printf>
        continue;
 338:	83 c4 10             	add    $0x10,%esp
 33b:	e9 c0 fe ff ff       	jmp    200 <ls+0x100>

00000340 <strcpy>:
    return val;
}

char*
strcpy(char *s, const char *t)
{
 340:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 341:	31 c0                	xor    %eax,%eax
{
 343:	89 e5                	mov    %esp,%ebp
 345:	53                   	push   %ebx
 346:	8b 4d 08             	mov    0x8(%ebp),%ecx
 349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 350:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 354:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 357:	83 c0 01             	add    $0x1,%eax
 35a:	84 d2                	test   %dl,%dl
 35c:	75 f2                	jne    350 <strcpy+0x10>
    ;
  return os;
}
 35e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 361:	89 c8                	mov    %ecx,%eax
 363:	c9                   	leave  
 364:	c3                   	ret    
 365:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 37a:	0f b6 02             	movzbl (%edx),%eax
 37d:	84 c0                	test   %al,%al
 37f:	75 17                	jne    398 <strcmp+0x28>
 381:	eb 3a                	jmp    3bd <strcmp+0x4d>
 383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 387:	90                   	nop
 388:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 38c:	83 c2 01             	add    $0x1,%edx
 38f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 392:	84 c0                	test   %al,%al
 394:	74 1a                	je     3b0 <strcmp+0x40>
    p++, q++;
 396:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 398:	0f b6 19             	movzbl (%ecx),%ebx
 39b:	38 c3                	cmp    %al,%bl
 39d:	74 e9                	je     388 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 39f:	29 d8                	sub    %ebx,%eax
}
 3a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    
 3a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 3b0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3b4:	31 c0                	xor    %eax,%eax
 3b6:	29 d8                	sub    %ebx,%eax
}
 3b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 3bd:	0f b6 19             	movzbl (%ecx),%ebx
 3c0:	31 c0                	xor    %eax,%eax
 3c2:	eb db                	jmp    39f <strcmp+0x2f>
 3c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <strlen>:

uint
strlen(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 3a 00             	cmpb   $0x0,(%edx)
 3d9:	74 15                	je     3f0 <strlen+0x20>
 3db:	31 c0                	xor    %eax,%eax
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 c0 01             	add    $0x1,%eax
 3e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3e7:	89 c1                	mov    %eax,%ecx
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	89 c8                	mov    %ecx,%eax
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    
 3ef:	90                   	nop
  for(n = 0; s[n]; n++)
 3f0:	31 c9                	xor    %ecx,%ecx
}
 3f2:	5d                   	pop    %ebp
 3f3:	89 c8                	mov    %ecx,%eax
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	8b 7d fc             	mov    -0x4(%ebp),%edi
 415:	89 d0                	mov    %edx,%eax
 417:	c9                   	leave  
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 12                	jne    443 <strchr+0x23>
 431:	eb 1d                	jmp    450 <strchr+0x30>
 433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 437:	90                   	nop
 438:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 43c:	83 c0 01             	add    $0x1,%eax
 43f:	84 d2                	test   %dl,%dl
 441:	74 0d                	je     450 <strchr+0x30>
    if(*s == c)
 443:	38 d1                	cmp    %dl,%cl
 445:	75 f1                	jne    438 <strchr+0x18>
      return (char*)s;
  return 0;
}
 447:	5d                   	pop    %ebp
 448:	c3                   	ret    
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 450:	31 c0                	xor    %eax,%eax
}
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 465:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 468:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 469:	31 db                	xor    %ebx,%ebx
{
 46b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 46e:	eb 27                	jmp    497 <gets+0x37>
    cc = read(0, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	6a 00                	push   $0x0
 478:	e8 ee 01 00 00       	call   66b <read>
    if(cc < 1)
 47d:	83 c4 10             	add    $0x10,%esp
 480:	85 c0                	test   %eax,%eax
 482:	7e 1d                	jle    4a1 <gets+0x41>
      break;
    buf[i++] = c;
 484:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 488:	8b 55 08             	mov    0x8(%ebp),%edx
 48b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 48f:	3c 0a                	cmp    $0xa,%al
 491:	74 1d                	je     4b0 <gets+0x50>
 493:	3c 0d                	cmp    $0xd,%al
 495:	74 19                	je     4b0 <gets+0x50>
  for(i=0; i+1 < max; ){
 497:	89 de                	mov    %ebx,%esi
 499:	83 c3 01             	add    $0x1,%ebx
 49c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 49f:	7c cf                	jl     470 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    
  buf[i] = '\0';
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	89 de                	mov    %ebx,%esi
 4b5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 4b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bc:	5b                   	pop    %ebx
 4bd:	5e                   	pop    %esi
 4be:	5f                   	pop    %edi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	push   0x8(%ebp)
 4dd:	e8 b1 01 00 00       	call   693 <open>
  if(fd < 0)
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	push   0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 b4 01 00 00       	call   6ab <fstat>
  close(fd);
 4f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4fa:	89 c6                	mov    %eax,%esi
  close(fd);
 4fc:	e8 7a 01 00 00       	call   67b <close>
  return r;
 501:	83 c4 10             	add    $0x10,%esp
}
 504:	8d 65 f8             	lea    -0x8(%ebp),%esp
 507:	89 f0                	mov    %esi,%eax
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
 515:	eb ed                	jmp    504 <stat+0x34>
 517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51e:	66 90                	xchg   %ax,%ax

00000520 <atoi>:

int
atoi(const char *s)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 527:	0f be 02             	movsbl (%edx),%eax
 52a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 52d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 530:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 535:	77 1e                	ja     555 <atoi+0x35>
 537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 540:	83 c2 01             	add    $0x1,%edx
 543:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 546:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 54a:	0f be 02             	movsbl (%edx),%eax
 54d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
  return n;
}
 555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 558:	89 c8                	mov    %ecx,%eax
 55a:	c9                   	leave  
 55b:	c3                   	ret    
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	8b 45 10             	mov    0x10(%ebp),%eax
 567:	8b 55 08             	mov    0x8(%ebp),%edx
 56a:	56                   	push   %esi
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56e:	85 c0                	test   %eax,%eax
 570:	7e 13                	jle    585 <memmove+0x25>
 572:	01 d0                	add    %edx,%eax
  dst = vdst;
 574:	89 d7                	mov    %edx,%edi
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 580:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 581:	39 f8                	cmp    %edi,%eax
 583:	75 fb                	jne    580 <memmove+0x20>
  return vdst;
}
 585:	5e                   	pop    %esi
 586:	89 d0                	mov    %edx,%eax
 588:	5f                   	pop    %edi
 589:	5d                   	pop    %ebp
 58a:	c3                   	ret    
 58b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop

00000590 <thread_create>:

int 
thread_create(void (*start_routine)(void *, void *), void* arg1, void* arg2)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	83 ec 14             	sub    $0x14,%esp
  void* stack;
  stack = malloc(PGSIZE);
 596:	68 00 10 00 00       	push   $0x1000
 59b:	e8 50 04 00 00       	call   9f0 <malloc>
  // printf(1 , "%d" , stack);
  return clone(start_routine, arg1, arg2, stack);
 5a0:	50                   	push   %eax
 5a1:	ff 75 10             	push   0x10(%ebp)
 5a4:	ff 75 0c             	push   0xc(%ebp)
 5a7:	ff 75 08             	push   0x8(%ebp)
 5aa:	e8 44 01 00 00       	call   6f3 <clone>
}
 5af:	c9                   	leave  
 5b0:	c3                   	ret    
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop

000005c0 <thread_join>:

int 
thread_join() 
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 34             	sub    $0x34,%esp
  void *stack;
  int ret_pid = join(&stack);
 5c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5c9:	50                   	push   %eax
 5ca:	e8 2c 01 00 00       	call   6fb <join>

  if (ret_pid != -1) 
 5cf:	83 c4 10             	add    $0x10,%esp
 5d2:	83 f8 ff             	cmp    $0xffffffff,%eax
 5d5:	75 09                	jne    5e0 <thread_join+0x20>
    free(stack);
  }

  return ret_pid;

}
 5d7:	c9                   	leave  
 5d8:	c3                   	ret    
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    free(stack);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	ff 75 f4             	push   -0xc(%ebp)
 5e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 5e9:	e8 72 03 00 00       	call   960 <free>
 5ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f1:	83 c4 10             	add    $0x10,%esp
}
 5f4:	c9                   	leave  
 5f5:	c3                   	ret    
 5f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi

00000600 <lock_init>:

void lock_init(lock_t *lock)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->ticket = 0;
 606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  lock->turn = 0;
 60d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 613:	5d                   	pop    %ebp
 614:	c3                   	ret    
 615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <lock_acquire>:

void lock_acquire(lock_t *lock){
 620:	55                   	push   %ebp
    __asm__ volatile
 621:	b8 01 00 00 00       	mov    $0x1,%eax
void lock_acquire(lock_t *lock){
 626:	89 e5                	mov    %esp,%ebp
 628:	8b 55 08             	mov    0x8(%ebp),%edx
    __asm__ volatile
 62b:	f0 0f c1 42 04       	lock xadd %eax,0x4(%edx)
  int myTurn = fetch_and_add(&lock->ticket , 1);
  while ( lock->turn != myTurn) 
 630:	8b 12                	mov    (%edx),%edx
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 638:	39 c2                	cmp    %eax,%edx
 63a:	75 fc                	jne    638 <lock_acquire+0x18>
  {}; // keep spinning
}
 63c:	5d                   	pop    %ebp
 63d:	c3                   	ret    
 63e:	66 90                	xchg   %ax,%ax

00000640 <lock_release>:

void lock_release(lock_t *lock){
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	8b 45 08             	mov    0x8(%ebp),%eax
	lock->turn += 1;
 646:	83 00 01             	addl   $0x1,(%eax)
}
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    

0000064b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 64b:	b8 01 00 00 00       	mov    $0x1,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <exit>:
SYSCALL(exit)
 653:	b8 02 00 00 00       	mov    $0x2,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <wait>:
SYSCALL(wait)
 65b:	b8 03 00 00 00       	mov    $0x3,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <pipe>:
SYSCALL(pipe)
 663:	b8 04 00 00 00       	mov    $0x4,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <read>:
SYSCALL(read)
 66b:	b8 05 00 00 00       	mov    $0x5,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <write>:
SYSCALL(write)
 673:	b8 10 00 00 00       	mov    $0x10,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <close>:
SYSCALL(close)
 67b:	b8 15 00 00 00       	mov    $0x15,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <kill>:
SYSCALL(kill)
 683:	b8 06 00 00 00       	mov    $0x6,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <exec>:
SYSCALL(exec)
 68b:	b8 07 00 00 00       	mov    $0x7,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <open>:
SYSCALL(open)
 693:	b8 0f 00 00 00       	mov    $0xf,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <mknod>:
SYSCALL(mknod)
 69b:	b8 11 00 00 00       	mov    $0x11,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <unlink>:
SYSCALL(unlink)
 6a3:	b8 12 00 00 00       	mov    $0x12,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <fstat>:
SYSCALL(fstat)
 6ab:	b8 08 00 00 00       	mov    $0x8,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <link>:
SYSCALL(link)
 6b3:	b8 13 00 00 00       	mov    $0x13,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <mkdir>:
SYSCALL(mkdir)
 6bb:	b8 14 00 00 00       	mov    $0x14,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <chdir>:
SYSCALL(chdir)
 6c3:	b8 09 00 00 00       	mov    $0x9,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <dup>:
SYSCALL(dup)
 6cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <getpid>:
SYSCALL(getpid)
 6d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <sbrk>:
SYSCALL(sbrk)
 6db:	b8 0c 00 00 00       	mov    $0xc,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <sleep>:
SYSCALL(sleep)
 6e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <uptime>:
SYSCALL(uptime)
 6eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <clone>:
SYSCALL(clone)
 6f3:	b8 16 00 00 00       	mov    $0x16,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <join>:
 6fb:	b8 17 00 00 00       	mov    $0x17,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    
 703:	66 90                	xchg   %ax,%ax
 705:	66 90                	xchg   %ax,%ax
 707:	66 90                	xchg   %ax,%ax
 709:	66 90                	xchg   %ax,%ax
 70b:	66 90                	xchg   %ax,%ax
 70d:	66 90                	xchg   %ax,%ax
 70f:	90                   	nop

00000710 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 3c             	sub    $0x3c,%esp
 719:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 71c:	89 d1                	mov    %edx,%ecx
{
 71e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 721:	85 d2                	test   %edx,%edx
 723:	0f 89 7f 00 00 00    	jns    7a8 <printint+0x98>
 729:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 72d:	74 79                	je     7a8 <printint+0x98>
    neg = 1;
 72f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 736:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 738:	31 db                	xor    %ebx,%ebx
 73a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 740:	89 c8                	mov    %ecx,%eax
 742:	31 d2                	xor    %edx,%edx
 744:	89 cf                	mov    %ecx,%edi
 746:	f7 75 c4             	divl   -0x3c(%ebp)
 749:	0f b6 92 94 0b 00 00 	movzbl 0xb94(%edx),%edx
 750:	89 45 c0             	mov    %eax,-0x40(%ebp)
 753:	89 d8                	mov    %ebx,%eax
 755:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 758:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 75b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 75e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 761:	76 dd                	jbe    740 <printint+0x30>
  if(neg)
 763:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 766:	85 c9                	test   %ecx,%ecx
 768:	74 0c                	je     776 <printint+0x66>
    buf[i++] = '-';
 76a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 76f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 771:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 776:	8b 7d b8             	mov    -0x48(%ebp),%edi
 779:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 77d:	eb 07                	jmp    786 <printint+0x76>
 77f:	90                   	nop
    putc(fd, buf[i]);
 780:	0f b6 13             	movzbl (%ebx),%edx
 783:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 786:	83 ec 04             	sub    $0x4,%esp
 789:	88 55 d7             	mov    %dl,-0x29(%ebp)
 78c:	6a 01                	push   $0x1
 78e:	56                   	push   %esi
 78f:	57                   	push   %edi
 790:	e8 de fe ff ff       	call   673 <write>
  while(--i >= 0)
 795:	83 c4 10             	add    $0x10,%esp
 798:	39 de                	cmp    %ebx,%esi
 79a:	75 e4                	jne    780 <printint+0x70>
}
 79c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 79f:	5b                   	pop    %ebx
 7a0:	5e                   	pop    %esi
 7a1:	5f                   	pop    %edi
 7a2:	5d                   	pop    %ebp
 7a3:	c3                   	ret    
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 7a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 7af:	eb 87                	jmp    738 <printint+0x28>
 7b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop

000007c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 7cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 7cf:	0f b6 13             	movzbl (%ebx),%edx
 7d2:	84 d2                	test   %dl,%dl
 7d4:	74 6a                	je     840 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 7d6:	8d 45 10             	lea    0x10(%ebp),%eax
 7d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 7dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 7df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 7e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7e4:	eb 36                	jmp    81c <printf+0x5c>
 7e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ed:	8d 76 00             	lea    0x0(%esi),%esi
 7f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 7f8:	83 f8 25             	cmp    $0x25,%eax
 7fb:	74 15                	je     812 <printf+0x52>
  write(fd, &c, 1);
 7fd:	83 ec 04             	sub    $0x4,%esp
 800:	88 55 e7             	mov    %dl,-0x19(%ebp)
 803:	6a 01                	push   $0x1
 805:	57                   	push   %edi
 806:	56                   	push   %esi
 807:	e8 67 fe ff ff       	call   673 <write>
 80c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 80f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 812:	0f b6 13             	movzbl (%ebx),%edx
 815:	83 c3 01             	add    $0x1,%ebx
 818:	84 d2                	test   %dl,%dl
 81a:	74 24                	je     840 <printf+0x80>
    c = fmt[i] & 0xff;
 81c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 81f:	85 c9                	test   %ecx,%ecx
 821:	74 cd                	je     7f0 <printf+0x30>
      }
    } else if(state == '%'){
 823:	83 f9 25             	cmp    $0x25,%ecx
 826:	75 ea                	jne    812 <printf+0x52>
      if(c == 'd'){
 828:	83 f8 25             	cmp    $0x25,%eax
 82b:	0f 84 07 01 00 00    	je     938 <printf+0x178>
 831:	83 e8 63             	sub    $0x63,%eax
 834:	83 f8 15             	cmp    $0x15,%eax
 837:	77 17                	ja     850 <printf+0x90>
 839:	ff 24 85 3c 0b 00 00 	jmp    *0xb3c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 840:	8d 65 f4             	lea    -0xc(%ebp),%esp
 843:	5b                   	pop    %ebx
 844:	5e                   	pop    %esi
 845:	5f                   	pop    %edi
 846:	5d                   	pop    %ebp
 847:	c3                   	ret    
 848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84f:	90                   	nop
  write(fd, &c, 1);
 850:	83 ec 04             	sub    $0x4,%esp
 853:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 856:	6a 01                	push   $0x1
 858:	57                   	push   %edi
 859:	56                   	push   %esi
 85a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 85e:	e8 10 fe ff ff       	call   673 <write>
        putc(fd, c);
 863:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 867:	83 c4 0c             	add    $0xc,%esp
 86a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 86d:	6a 01                	push   $0x1
 86f:	57                   	push   %edi
 870:	56                   	push   %esi
 871:	e8 fd fd ff ff       	call   673 <write>
        putc(fd, c);
 876:	83 c4 10             	add    $0x10,%esp
      state = 0;
 879:	31 c9                	xor    %ecx,%ecx
 87b:	eb 95                	jmp    812 <printf+0x52>
 87d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 10 00 00 00       	mov    $0x10,%ecx
 888:	6a 00                	push   $0x0
 88a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	89 f0                	mov    %esi,%eax
 891:	e8 7a fe ff ff       	call   710 <printint>
        ap++;
 896:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 89a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 89d:	31 c9                	xor    %ecx,%ecx
 89f:	e9 6e ff ff ff       	jmp    812 <printf+0x52>
 8a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 8a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8ab:	8b 10                	mov    (%eax),%edx
        ap++;
 8ad:	83 c0 04             	add    $0x4,%eax
 8b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8b3:	85 d2                	test   %edx,%edx
 8b5:	0f 84 8d 00 00 00    	je     948 <printf+0x188>
        while(*s != 0){
 8bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 8be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 8c0:	84 c0                	test   %al,%al
 8c2:	0f 84 4a ff ff ff    	je     812 <printf+0x52>
 8c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8cb:	89 d3                	mov    %edx,%ebx
 8cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8d3:	83 c3 01             	add    $0x1,%ebx
 8d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8d9:	6a 01                	push   $0x1
 8db:	57                   	push   %edi
 8dc:	56                   	push   %esi
 8dd:	e8 91 fd ff ff       	call   673 <write>
        while(*s != 0){
 8e2:	0f b6 03             	movzbl (%ebx),%eax
 8e5:	83 c4 10             	add    $0x10,%esp
 8e8:	84 c0                	test   %al,%al
 8ea:	75 e4                	jne    8d0 <printf+0x110>
      state = 0;
 8ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 8ef:	31 c9                	xor    %ecx,%ecx
 8f1:	e9 1c ff ff ff       	jmp    812 <printf+0x52>
 8f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 900:	83 ec 0c             	sub    $0xc,%esp
 903:	b9 0a 00 00 00       	mov    $0xa,%ecx
 908:	6a 01                	push   $0x1
 90a:	e9 7b ff ff ff       	jmp    88a <printf+0xca>
 90f:	90                   	nop
        putc(fd, *ap);
 910:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 913:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 916:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 918:	6a 01                	push   $0x1
 91a:	57                   	push   %edi
 91b:	56                   	push   %esi
        putc(fd, *ap);
 91c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 91f:	e8 4f fd ff ff       	call   673 <write>
        ap++;
 924:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 928:	83 c4 10             	add    $0x10,%esp
      state = 0;
 92b:	31 c9                	xor    %ecx,%ecx
 92d:	e9 e0 fe ff ff       	jmp    812 <printf+0x52>
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 938:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 93b:	83 ec 04             	sub    $0x4,%esp
 93e:	e9 2a ff ff ff       	jmp    86d <printf+0xad>
 943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 947:	90                   	nop
          s = "(null)";
 948:	ba 32 0b 00 00       	mov    $0xb32,%edx
        while(*s != 0){
 94d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 950:	b8 28 00 00 00       	mov    $0x28,%eax
 955:	89 d3                	mov    %edx,%ebx
 957:	e9 74 ff ff ff       	jmp    8d0 <printf+0x110>
 95c:	66 90                	xchg   %ax,%ax
 95e:	66 90                	xchg   %ax,%ax

00000960 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 960:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 961:	a1 7c 0f 00 00       	mov    0xf7c,%eax
{
 966:	89 e5                	mov    %esp,%ebp
 968:	57                   	push   %edi
 969:	56                   	push   %esi
 96a:	53                   	push   %ebx
 96b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 96e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 978:	89 c2                	mov    %eax,%edx
 97a:	8b 00                	mov    (%eax),%eax
 97c:	39 ca                	cmp    %ecx,%edx
 97e:	73 30                	jae    9b0 <free+0x50>
 980:	39 c1                	cmp    %eax,%ecx
 982:	72 04                	jb     988 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 984:	39 c2                	cmp    %eax,%edx
 986:	72 f0                	jb     978 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 988:	8b 73 fc             	mov    -0x4(%ebx),%esi
 98b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 98e:	39 f8                	cmp    %edi,%eax
 990:	74 30                	je     9c2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 992:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 995:	8b 42 04             	mov    0x4(%edx),%eax
 998:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 99b:	39 f1                	cmp    %esi,%ecx
 99d:	74 3a                	je     9d9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 99f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 9a1:	5b                   	pop    %ebx
  freep = p;
 9a2:	89 15 7c 0f 00 00    	mov    %edx,0xf7c
}
 9a8:	5e                   	pop    %esi
 9a9:	5f                   	pop    %edi
 9aa:	5d                   	pop    %ebp
 9ab:	c3                   	ret    
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	39 c2                	cmp    %eax,%edx
 9b2:	72 c4                	jb     978 <free+0x18>
 9b4:	39 c1                	cmp    %eax,%ecx
 9b6:	73 c0                	jae    978 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 9b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 9be:	39 f8                	cmp    %edi,%eax
 9c0:	75 d0                	jne    992 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 9c2:	03 70 04             	add    0x4(%eax),%esi
 9c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	8b 02                	mov    (%edx),%eax
 9ca:	8b 00                	mov    (%eax),%eax
 9cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 9cf:	8b 42 04             	mov    0x4(%edx),%eax
 9d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 9d5:	39 f1                	cmp    %esi,%ecx
 9d7:	75 c6                	jne    99f <free+0x3f>
    p->s.size += bp->s.size;
 9d9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 9dc:	89 15 7c 0f 00 00    	mov    %edx,0xf7c
    p->s.size += bp->s.size;
 9e2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 9e5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 9e8:	89 0a                	mov    %ecx,(%edx)
}
 9ea:	5b                   	pop    %ebx
 9eb:	5e                   	pop    %esi
 9ec:	5f                   	pop    %edi
 9ed:	5d                   	pop    %ebp
 9ee:	c3                   	ret    
 9ef:	90                   	nop

000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	57                   	push   %edi
 9f4:	56                   	push   %esi
 9f5:	53                   	push   %ebx
 9f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9fc:	8b 3d 7c 0f 00 00    	mov    0xf7c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a02:	8d 70 07             	lea    0x7(%eax),%esi
 a05:	c1 ee 03             	shr    $0x3,%esi
 a08:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 a0b:	85 ff                	test   %edi,%edi
 a0d:	0f 84 9d 00 00 00    	je     ab0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a13:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 a15:	8b 4a 04             	mov    0x4(%edx),%ecx
 a18:	39 f1                	cmp    %esi,%ecx
 a1a:	73 6a                	jae    a86 <malloc+0x96>
 a1c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a21:	39 de                	cmp    %ebx,%esi
 a23:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a26:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a30:	eb 17                	jmp    a49 <malloc+0x59>
 a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a3a:	8b 48 04             	mov    0x4(%eax),%ecx
 a3d:	39 f1                	cmp    %esi,%ecx
 a3f:	73 4f                	jae    a90 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a41:	8b 3d 7c 0f 00 00    	mov    0xf7c,%edi
 a47:	89 c2                	mov    %eax,%edx
 a49:	39 d7                	cmp    %edx,%edi
 a4b:	75 eb                	jne    a38 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a4d:	83 ec 0c             	sub    $0xc,%esp
 a50:	ff 75 e4             	push   -0x1c(%ebp)
 a53:	e8 83 fc ff ff       	call   6db <sbrk>
  if(p == (char*)-1)
 a58:	83 c4 10             	add    $0x10,%esp
 a5b:	83 f8 ff             	cmp    $0xffffffff,%eax
 a5e:	74 1c                	je     a7c <malloc+0x8c>
  hp->s.size = nu;
 a60:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a63:	83 ec 0c             	sub    $0xc,%esp
 a66:	83 c0 08             	add    $0x8,%eax
 a69:	50                   	push   %eax
 a6a:	e8 f1 fe ff ff       	call   960 <free>
  return freep;
 a6f:	8b 15 7c 0f 00 00    	mov    0xf7c,%edx
      if((p = morecore(nunits)) == 0)
 a75:	83 c4 10             	add    $0x10,%esp
 a78:	85 d2                	test   %edx,%edx
 a7a:	75 bc                	jne    a38 <malloc+0x48>
        return 0;
  }
}
 a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a7f:	31 c0                	xor    %eax,%eax
}
 a81:	5b                   	pop    %ebx
 a82:	5e                   	pop    %esi
 a83:	5f                   	pop    %edi
 a84:	5d                   	pop    %ebp
 a85:	c3                   	ret    
    if(p->s.size >= nunits){
 a86:	89 d0                	mov    %edx,%eax
 a88:	89 fa                	mov    %edi,%edx
 a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a90:	39 ce                	cmp    %ecx,%esi
 a92:	74 4c                	je     ae0 <malloc+0xf0>
        p->s.size -= nunits;
 a94:	29 f1                	sub    %esi,%ecx
 a96:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a99:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a9c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a9f:	89 15 7c 0f 00 00    	mov    %edx,0xf7c
}
 aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 aa8:	83 c0 08             	add    $0x8,%eax
}
 aab:	5b                   	pop    %ebx
 aac:	5e                   	pop    %esi
 aad:	5f                   	pop    %edi
 aae:	5d                   	pop    %ebp
 aaf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 ab0:	c7 05 7c 0f 00 00 80 	movl   $0xf80,0xf7c
 ab7:	0f 00 00 
    base.s.size = 0;
 aba:	bf 80 0f 00 00       	mov    $0xf80,%edi
    base.s.ptr = freep = prevp = &base;
 abf:	c7 05 80 0f 00 00 80 	movl   $0xf80,0xf80
 ac6:	0f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 acb:	c7 05 84 0f 00 00 00 	movl   $0x0,0xf84
 ad2:	00 00 00 
    if(p->s.size >= nunits){
 ad5:	e9 42 ff ff ff       	jmp    a1c <malloc+0x2c>
 ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ae0:	8b 08                	mov    (%eax),%ecx
 ae2:	89 0a                	mov    %ecx,(%edx)
 ae4:	eb b9                	jmp    a9f <malloc+0xaf>
