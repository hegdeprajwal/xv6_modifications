
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 55 11 80       	mov    $0x801155d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 25 46 00 00       	call   80104680 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 b3 44 00 00       	call   80104550 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 67 47 00 00       	call   80104850 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 89 46 00 00       	call   801047f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 44 00 00       	call   80104590 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 74 10 80       	push   $0x801074ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 44 00 00       	call   80104630 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 74 10 80       	push   $0x801074ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 43 00 00       	call   801045f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 30 46 00 00       	call   80104850 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 45 00 00       	jmp    801047f0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 75 10 80       	push   $0x80107506
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 ab 45 00 00       	call   80104850 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 6e 3d 00 00       	call   80104040 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 36 00 00       	call   80103970 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 f5 44 00 00       	call   801047f0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 9f 44 00 00       	call   801047f0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 75 10 80       	push   $0x8010750d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 9f 7e 10 80 	movl   $0x80107e9f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 42 00 00       	call   801046a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 75 10 80       	push   $0x80107521
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 5b 00 00       	call   80105ff0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 e6 5a 00 00       	call   80105ff0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 da 5a 00 00       	call   80105ff0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ce 5a 00 00       	call   80105ff0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 5a 44 00 00       	call   801049b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 a5 43 00 00       	call   80104910 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 75 10 80       	push   $0x80107525
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 a0 42 00 00       	call   80104850 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 07 42 00 00       	call   801047f0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 63 40 00 00       	call   80104850 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 75 10 80       	mov    $0x80107538,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 90 3f 00 00       	call   801047f0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 75 10 80       	push   $0x8010753f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 b8 3f 00 00       	call   80104850 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 1b 3e 00 00       	call   801047f0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 cd 37 00 00       	jmp    801041e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 b7 36 00 00       	call   80104100 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 75 10 80       	push   $0x80107548
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 0b 3c 00 00       	call   80104680 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 af 2e 00 00       	call   80103970 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 47 66 00 00       	call   80107180 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 f8 63 00 00       	call   80106fa0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 d2 62 00 00       	call   80106eb0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 e0 64 00 00       	call   80107100 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 39 63 00 00       	call   80106fa0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 98 65 00 00       	call   80107220 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 38 3e 00 00       	call   80104b10 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 24 3e 00 00       	call   80104b10 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 f3 66 00 00       	call   801073f0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ea 63 00 00       	call   80107100 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 88 66 00 00       	call   801073f0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 2a 3d 00 00       	call   80104ad0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 4e 5f 00 00       	call   80106d20 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 26 63 00 00       	call   80107100 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 75 10 80       	push   $0x80107561
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 75 10 80       	push   $0x8010756d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 5b 38 00 00       	call   80104680 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 0a 3a 00 00       	call   80104850 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 7a 39 00 00       	call   801047f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 61 39 00 00       	call   801047f0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 9c 39 00 00       	call   80104850 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 1f 39 00 00       	call   801047f0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 75 10 80       	push   $0x80107574
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 4a 39 00 00       	call   80104850 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 af 38 00 00       	call   801047f0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 7d 38 00 00       	jmp    801047f0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 7c 75 10 80       	push   $0x8010757c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 75 10 80       	push   $0x80107586
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 8f 75 10 80       	push   $0x8010758f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 95 75 10 80       	push   $0x80107595
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 75 10 80       	push   $0x8010759f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 75 10 80       	push   $0x801075b2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 e6 35 00 00       	call   80104910 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 e1 34 00 00       	call   80104850 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 14 34 00 00       	call   801047f0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 e6 33 00 00       	call   801047f0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 c8 75 10 80       	push   $0x801075c8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 d8 75 10 80       	push   $0x801075d8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 6a 34 00 00       	call   801049b0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 eb 75 10 80       	push   $0x801075eb
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 05 31 00 00       	call   80104680 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 f2 75 10 80       	push   $0x801075f2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 bc 2f 00 00       	call   80104550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 ef 33 00 00       	call   801049b0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 58 76 10 80       	push   $0x80107658
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 7d 32 00 00       	call   80104910 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 f8 75 10 80       	push   $0x801075f8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 7a 32 00 00       	call   801049b0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 ec 30 00 00       	call   80104850 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 7c 30 00 00       	call   801047f0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 e9 2d 00 00       	call   80104590 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 93 31 00 00       	call   801049b0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 10 76 10 80       	push   $0x80107610
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 76 10 80       	push   $0x8010760a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 b8 2d 00 00       	call   80104630 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 5c 2d 00 00       	jmp    801045f0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 76 10 80       	push   $0x8010761f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 cb 2c 00 00       	call   80104590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 11 2d 00 00       	call   801045f0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 65 2f 00 00       	call   80104850 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 eb 2e 00 00       	jmp    801047f0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 3b 2f 00 00       	call   80104850 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 cc 2e 00 00       	call   801047f0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 08 2c 00 00       	call   80104630 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 b1 2b 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 1f 76 10 80       	push   $0x8010761f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 74 2e 00 00       	call   801049b0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 78 2d 00 00       	call   801049b0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 4d 2d 00 00       	call   80104a20 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 ee 2c 00 00       	call   80104a20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 39 76 10 80       	push   $0x80107639
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 27 76 10 80       	push   $0x80107627
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 c1 1b 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 91 2a 00 00       	call   80104850 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 21 2a 00 00       	call   801047f0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 84 2b 00 00       	call   801049b0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 9f 27 00 00       	call   80104630 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 3d 27 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 d0 2a 00 00       	call   801049b0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 00 27 00 00       	call   80104630 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 a1 26 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 be 26 00 00       	call   80104630 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 9b 26 00 00       	call   80104630 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 44 26 00 00       	call   801045f0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 1f 76 10 80       	push   $0x8010761f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 2e 2a 00 00       	call   80104a70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 48 76 10 80       	push   $0x80107648
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 86 7c 10 80       	push   $0x80107c86
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe b7 0b 00 00    	cmp    $0xbb7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 b4 76 10 80       	push   $0x801076b4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ab 76 10 80       	push   $0x801076ab
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 c6 76 10 80       	push   $0x801076c6
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 ab 24 00 00       	call   80104680 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 fd 25 00 00       	call   80104850 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 4e 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 20 25 00 00       	call   801047f0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 3d 23 00 00       	call   80104630 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 23 25 00 00       	call   80104850 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 d2 1c 00 00       	call   80104040 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 65 24 00 00       	jmp    801047f0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 f5 76 10 80       	push   $0x801076f5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 e0 76 10 80       	push   $0x801076e0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ca 76 10 80       	push   $0x801076ca
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 14 77 10 80       	push   $0x80107714
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 55 11 80    	cmp    $0x801155d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 19 24 00 00       	call   80104910 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 16 11 80       	mov    0x80111678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 16 11 80       	push   $0x80111640
80102528:	e8 23 23 00 00       	call   80104850 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 a8 22 00 00       	jmp    801047f0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 46 77 10 80       	push   $0x80107746
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 4c 77 10 80       	push   $0x8010774c
80102620:	68 40 16 11 80       	push   $0x80111640
80102625:	e8 56 20 00 00       	call   80104680 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 16 11 80       	mov    0x80111674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 16 11 80       	push   $0x80111640
801026b3:	e8 98 21 00 00       	call   80104850 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 16 11 80       	push   $0x80111640
801026e1:	e8 0a 21 00 00       	call   801047f0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 80 78 10 80 	movzbl -0x7fef8780(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 80 77 10 80 	movzbl -0x7fef8880(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 16 11 80       	mov    0x80111680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 64 1e 00 00       	call   80104960 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 16 11 80    	push   0x801116e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 87 1d 00 00       	call   801049b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 16 11 80    	push   0x801116d4
80102c6d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 80 79 10 80       	push   $0x80107980
80102ccf:	68 a0 16 11 80       	push   $0x801116a0
80102cd4:	e8 a7 19 00 00       	call   80104680 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 16 11 80       	push   $0x801116a0
80102d6b:	e8 e0 1a 00 00       	call   80104850 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 16 11 80       	push   $0x801116a0
80102d80:	68 a0 16 11 80       	push   $0x801116a0
80102d85:	e8 b6 12 00 00       	call   80104040 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d9b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102db7:	68 a0 16 11 80       	push   $0x801116a0
80102dbc:	e8 2f 1a 00 00       	call   801047f0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 16 11 80       	push   $0x801116a0
80102dde:	e8 6d 1a 00 00       	call   80104850 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 16 11 80       	push   $0x801116a0
80102e1c:	e8 cf 19 00 00       	call   801047f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 16 11 80       	push   $0x801116a0
80102e36:	e8 15 1a 00 00       	call   80104850 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 af 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e58:	e8 93 19 00 00       	call   801047f0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e94:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 f7 1a 00 00       	call   801049b0 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 16 11 80       	push   $0x801116a0
80102f08:	e8 f3 11 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f14:	e8 d7 18 00 00       	call   801047f0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 84 79 10 80       	push   $0x80107984
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 16 11 80       	push   $0x801116a0
80102f76:	e8 d5 18 00 00       	call   80104850 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 36 18 00 00       	jmp    801047f0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 93 79 10 80       	push   $0x80107993
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 a9 79 10 80       	push   $0x801079a9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 44 09 00 00       	call   80103950 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 3d 09 00 00       	call   80103950 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 c4 79 10 80       	push   $0x801079c4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 f9 2b 00 00       	call   80105c20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 c4 08 00 00       	call   801038f0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 f1 0b 00 00       	call   80103c30 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 c5 3c 00 00       	call   80106d10 <switchkvm>
  seginit();
8010304b:	e8 30 3c 00 00       	call   80106c80 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 d0 55 11 80       	push   $0x801155d0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 7a 41 00 00       	call   80107200 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 eb 3b 00 00       	call   80106c80 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 67 2e 00 00       	call   80105f10 <uartinit>
  pinit();         // process table
801030a9:	e8 22 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 ed 2a 00 00       	call   80105ba0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c a4 10 80       	push   $0x8010a48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 d7 18 00 00       	call   801049b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030eb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 d2 07 00 00       	call   801038f0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 19 08 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 d8 79 10 80       	push   $0x801079d8
801031c3:	56                   	push   %esi
801031c4:	e8 97 17 00 00       	call   80104960 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 dd 79 10 80       	push   $0x801079dd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 dc 16 00 00       	call   80104960 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 e2 79 10 80       	push   $0x801079e2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 d8 79 10 80       	push   $0x801079d8
801033c7:	53                   	push   %ebx
801033c8:	e8 93 15 00 00       	call   80104960 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 fc 79 10 80       	push   $0x801079fc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 1b 7a 10 80       	push   $0x80107a1b
801034a8:	50                   	push   %eax
801034a9:	e8 d2 11 00 00       	call   80104680 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 0c 13 00 00       	call   80104850 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 9c 0b 00 00       	call   80104100 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 67 12 00 00       	jmp    801047f0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 57 12 00 00       	call   801047f0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 37 0b 00 00       	call   80104100 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 6e 12 00 00       	call   80104850 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 43 03 00 00       	call   80103970 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 c3 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 fa 09 00 00       	call   80104040 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 7f 11 00 00       	call   801047f0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 41 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 29 11 00 00       	call   801047f0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 65 11 00 00       	call   80104850 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 6b 02 00 00       	call   80103970 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 26 09 00 00       	call   80104040 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 85 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 6d 10 00 00       	call   801047f0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 52 10 00 00       	call   801047f0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 1d 11 80       	push   $0x80111d20
801037c1:	e8 8a 10 00 00       	call   80104850 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 10                	jmp    801037db <allocproc+0x2b>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	83 eb 80             	sub    $0xffffff80,%ebx
801037d3:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801037d9:	74 75                	je     80103850 <allocproc+0xa0>
    if(p->state == UNUSED)
801037db:	8b 43 0c             	mov    0xc(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	75 ee                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f1:	89 43 10             	mov    %eax,0x10(%ebx)
801037f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037f7:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
801037fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103802:	e8 e9 0f 00 00       	call   801047f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103807:	e8 74 ee ff ff       	call   80102680 <kalloc>
8010380c:	83 c4 10             	add    $0x10,%esp
8010380f:	89 43 08             	mov    %eax,0x8(%ebx)
80103812:	85 c0                	test   %eax,%eax
80103814:	74 53                	je     80103869 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103816:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010381f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103824:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103827:	c7 40 14 86 5b 10 80 	movl   $0x80105b86,0x14(%eax)
  p->context = (struct context*)sp;
8010382e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103831:	6a 14                	push   $0x14
80103833:	6a 00                	push   $0x0
80103835:	50                   	push   %eax
80103836:	e8 d5 10 00 00       	call   80104910 <memset>
  p->context->eip = (uint)forkret;
8010383b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010383e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103841:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
80103848:	89 d8                	mov    %ebx,%eax
8010384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384d:	c9                   	leave  
8010384e:	c3                   	ret    
8010384f:	90                   	nop
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 1d 11 80       	push   $0x80111d20
8010385a:	e8 91 0f 00 00       	call   801047f0 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103886:	68 20 1d 11 80       	push   $0x80111d20
8010388b:	e8 60 0f 00 00       	call   801047f0 <release>

  if (first) {
80103890:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	85 c0                	test   %eax,%eax
8010389a:	75 04                	jne    801038a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    
8010389e:	66 90                	xchg   %ax,%ax
    first = 0;
801038a0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038a7:	00 00 00 
    iinit(ROOTDEV);
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	6a 01                	push   $0x1
801038af:	e8 ac dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038bb:	e8 00 f4 ff ff       	call   80102cc0 <initlog>
}
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	c9                   	leave  
801038c4:	c3                   	ret    
801038c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038d0 <pinit>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038d6:	68 20 7a 10 80       	push   $0x80107a20
801038db:	68 20 1d 11 80       	push   $0x80111d20
801038e0:	e8 9b 0d 00 00       	call   80104680 <initlock>
}
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	c9                   	leave  
801038e9:	c3                   	ret    
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <mycpu>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f5:	9c                   	pushf  
801038f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038f7:	f6 c4 02             	test   $0x2,%ah
801038fa:	75 46                	jne    80103942 <mycpu+0x52>
  apicid = lapicid();
801038fc:	e8 ef ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103901:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103907:	85 f6                	test   %esi,%esi
80103909:	7e 2a                	jle    80103935 <mycpu+0x45>
8010390b:	31 d2                	xor    %edx,%edx
8010390d:	eb 08                	jmp    80103917 <mycpu+0x27>
8010390f:	90                   	nop
80103910:	83 c2 01             	add    $0x1,%edx
80103913:	39 f2                	cmp    %esi,%edx
80103915:	74 1e                	je     80103935 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103917:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010391d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103924:	39 c3                	cmp    %eax,%ebx
80103926:	75 e8                	jne    80103910 <mycpu+0x20>
}
80103928:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010392b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103931:	5b                   	pop    %ebx
80103932:	5e                   	pop    %esi
80103933:	5d                   	pop    %ebp
80103934:	c3                   	ret    
  panic("unknown apicid\n");
80103935:	83 ec 0c             	sub    $0xc,%esp
80103938:	68 27 7a 10 80       	push   $0x80107a27
8010393d:	e8 3e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103942:	83 ec 0c             	sub    $0xc,%esp
80103945:	68 04 7b 10 80       	push   $0x80107b04
8010394a:	e8 31 ca ff ff       	call   80100380 <panic>
8010394f:	90                   	nop

80103950 <cpuid>:
cpuid() {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103956:	e8 95 ff ff ff       	call   801038f0 <mycpu>
}
8010395b:	c9                   	leave  
  return mycpu()-cpus;
8010395c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103961:	c1 f8 04             	sar    $0x4,%eax
80103964:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396a:	c3                   	ret    
8010396b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop

80103970 <myproc>:
myproc(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103977:	e8 84 0d 00 00       	call   80104700 <pushcli>
  c = mycpu();
8010397c:	e8 6f ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103981:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103987:	e8 c4 0d 00 00       	call   80104750 <popcli>
}
8010398c:	89 d8                	mov    %ebx,%eax
8010398e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103991:	c9                   	leave  
80103992:	c3                   	ret    
80103993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039a0 <userinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039a7:	e8 04 fe ff ff       	call   801037b0 <allocproc>
801039ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ae:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if((p->pgdir = setupkvm()) == 0)
801039b3:	e8 c8 37 00 00       	call   80107180 <setupkvm>
801039b8:	89 43 04             	mov    %eax,0x4(%ebx)
801039bb:	85 c0                	test   %eax,%eax
801039bd:	0f 84 bd 00 00 00    	je     80103a80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c3:	83 ec 04             	sub    $0x4,%esp
801039c6:	68 2c 00 00 00       	push   $0x2c
801039cb:	68 60 a4 10 80       	push   $0x8010a460
801039d0:	50                   	push   %eax
801039d1:	e8 5a 34 00 00       	call   80106e30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039df:	6a 4c                	push   $0x4c
801039e1:	6a 00                	push   $0x0
801039e3:	ff 73 18             	push   0x18(%ebx)
801039e6:	e8 25 0f 00 00       	call   80104910 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039f6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a11:	8b 43 18             	mov    0x18(%ebx),%eax
80103a14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 50 7a 10 80       	push   $0x80107a50
80103a44:	50                   	push   %eax
80103a45:	e8 86 10 00 00       	call   80104ad0 <safestrcpy>
  p->cwd = namei("/");
80103a4a:	c7 04 24 59 7a 10 80 	movl   $0x80107a59,(%esp)
80103a51:	e8 4a e6 ff ff       	call   801020a0 <namei>
80103a56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a59:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a60:	e8 eb 0d 00 00       	call   80104850 <acquire>
  p->state = RUNNABLE;
80103a65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a6c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a73:	e8 78 0d 00 00       	call   801047f0 <release>
}
80103a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7b:	83 c4 10             	add    $0x10,%esp
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	68 37 7a 10 80       	push   $0x80107a37
80103a88:	e8 f3 c8 ff ff       	call   80100380 <panic>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

80103a90 <growproc>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a98:	e8 63 0c 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103a9d:	e8 4e fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103aa2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa8:	e8 a3 0c 00 00       	call   80104750 <popcli>
  sz = curproc->sz;
80103aad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aaf:	85 f6                	test   %esi,%esi
80103ab1:	7f 1d                	jg     80103ad0 <growproc+0x40>
  } else if(n < 0){
80103ab3:	75 3b                	jne    80103af0 <growproc+0x60>
  switchuvm(curproc);
80103ab5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ab8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aba:	53                   	push   %ebx
80103abb:	e8 60 32 00 00       	call   80106d20 <switchuvm>
  return 0;
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	31 c0                	xor    %eax,%eax
}
80103ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac8:	5b                   	pop    %ebx
80103ac9:	5e                   	pop    %esi
80103aca:	5d                   	pop    %ebp
80103acb:	c3                   	ret    
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	push   0x4(%ebx)
80103ada:	e8 c1 34 00 00       	call   80106fa0 <allocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 cf                	jne    80103ab5 <growproc+0x25>
      return -1;
80103ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aeb:	eb d8                	jmp    80103ac5 <growproc+0x35>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 d1 35 00 00       	call   801070d0 <deallocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 af                	jne    80103ab5 <growproc+0x25>
80103b06:	eb de                	jmp    80103ae6 <growproc+0x56>
80103b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop

80103b10 <fork>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b19:	e8 e2 0b 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103b1e:	e8 cd fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b29:	e8 22 0c 00 00       	call   80104750 <popcli>
  if((np = allocproc()) == 0){
80103b2e:	e8 7d fc ff ff       	call   801037b0 <allocproc>
80103b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b36:	85 c0                	test   %eax,%eax
80103b38:	0f 84 b7 00 00 00    	je     80103bf5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b3e:	83 ec 08             	sub    $0x8,%esp
80103b41:	ff 33                	push   (%ebx)
80103b43:	89 c7                	mov    %eax,%edi
80103b45:	ff 73 04             	push   0x4(%ebx)
80103b48:	e8 23 37 00 00       	call   80107270 <copyuvm>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	89 47 04             	mov    %eax,0x4(%edi)
80103b53:	85 c0                	test   %eax,%eax
80103b55:	0f 84 a1 00 00 00    	je     80103bfc <fork+0xec>
  np->sz = curproc->sz;
80103b5b:	8b 03                	mov    (%ebx),%eax
80103b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b65:	89 c8                	mov    %ecx,%eax
80103b67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b6f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b76:	8b 40 18             	mov    0x18(%eax),%eax
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 13                	je     80103b9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	50                   	push   %eax
80103b8c:	e8 0f d3 ff ff       	call   80100ea0 <filedup>
80103b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b94:	83 c4 10             	add    $0x10,%esp
80103b97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9b:	83 c6 01             	add    $0x1,%esi
80103b9e:	83 fe 10             	cmp    $0x10,%esi
80103ba1:	75 dd                	jne    80103b80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ba3:	83 ec 0c             	sub    $0xc,%esp
80103ba6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bac:	e8 9f db ff ff       	call   80101750 <idup>
80103bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	53                   	push   %ebx
80103bc0:	50                   	push   %eax
80103bc1:	e8 0a 0f 00 00       	call   80104ad0 <safestrcpy>
  pid = np->pid;
80103bc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bc9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bd0:	e8 7b 0c 00 00       	call   80104850 <acquire>
  np->state = RUNNABLE;
80103bd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bdc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103be3:	e8 08 0c 00 00       	call   801047f0 <release>
  return pid;
80103be8:	83 c4 10             	add    $0x10,%esp
}
80103beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bee:	89 d8                	mov    %ebx,%eax
80103bf0:	5b                   	pop    %ebx
80103bf1:	5e                   	pop    %esi
80103bf2:	5f                   	pop    %edi
80103bf3:	5d                   	pop    %ebp
80103bf4:	c3                   	ret    
    return -1;
80103bf5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bfa:	eb ef                	jmp    80103beb <fork+0xdb>
    kfree(np->kstack);
80103bfc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bff:	83 ec 0c             	sub    $0xc,%esp
80103c02:	ff 73 08             	push   0x8(%ebx)
80103c05:	e8 b6 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c11:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c14:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c20:	eb c9                	jmp    80103beb <fork+0xdb>
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c30 <scheduler>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c39:	e8 b2 fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c45:	00 00 00 
  struct cpu *c = mycpu();
80103c48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c4a:	8d 78 04             	lea    0x4(%eax),%edi
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c50:	fb                   	sti    
    acquire(&ptable.lock);
80103c51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c54:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c59:	68 20 1d 11 80       	push   $0x80111d20
80103c5e:	e8 ed 0b 00 00       	call   80104850 <acquire>
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c74:	75 33                	jne    80103ca9 <scheduler+0x79>
      switchuvm(p);
80103c76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c7f:	53                   	push   %ebx
80103c80:	e8 9b 30 00 00       	call   80106d20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c85:	58                   	pop    %eax
80103c86:	5a                   	pop    %edx
80103c87:	ff 73 1c             	push   0x1c(%ebx)
80103c8a:	57                   	push   %edi
      p->state = RUNNING;
80103c8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c92:	e8 94 0e 00 00       	call   80104b2b <swtch>
      switchkvm();
80103c97:	e8 74 30 00 00       	call   80106d10 <switchkvm>
      c->proc = 0;
80103c9c:	83 c4 10             	add    $0x10,%esp
80103c9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ca6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca9:	83 eb 80             	sub    $0xffffff80,%ebx
80103cac:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103cb2:	75 bc                	jne    80103c70 <scheduler+0x40>
    release(&ptable.lock);
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	68 20 1d 11 80       	push   $0x80111d20
80103cbc:	e8 2f 0b 00 00       	call   801047f0 <release>
    sti();
80103cc1:	83 c4 10             	add    $0x10,%esp
80103cc4:	eb 8a                	jmp    80103c50 <scheduler+0x20>
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi

80103cd0 <sched>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
  pushcli();
80103cd5:	e8 26 0a 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103cda:	e8 11 fc ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103cdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce5:	e8 66 0a 00 00       	call   80104750 <popcli>
  if(!holding(&ptable.lock))
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	68 20 1d 11 80       	push   $0x80111d20
80103cf2:	e8 b9 0a 00 00       	call   801047b0 <holding>
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	85 c0                	test   %eax,%eax
80103cfc:	74 4f                	je     80103d4d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cfe:	e8 ed fb ff ff       	call   801038f0 <mycpu>
80103d03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d0a:	75 68                	jne    80103d74 <sched+0xa4>
  if(p->state == RUNNING)
80103d0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d10:	74 55                	je     80103d67 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d12:	9c                   	pushf  
80103d13:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d14:	f6 c4 02             	test   $0x2,%ah
80103d17:	75 41                	jne    80103d5a <sched+0x8a>
  intena = mycpu()->intena;
80103d19:	e8 d2 fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d1e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d27:	e8 c4 fb ff ff       	call   801038f0 <mycpu>
80103d2c:	83 ec 08             	sub    $0x8,%esp
80103d2f:	ff 70 04             	push   0x4(%eax)
80103d32:	53                   	push   %ebx
80103d33:	e8 f3 0d 00 00       	call   80104b2b <swtch>
  mycpu()->intena = intena;
80103d38:	e8 b3 fb ff ff       	call   801038f0 <mycpu>
}
80103d3d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5d                   	pop    %ebp
80103d4c:	c3                   	ret    
    panic("sched ptable.lock");
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 5b 7a 10 80       	push   $0x80107a5b
80103d55:	e8 26 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 87 7a 10 80       	push   $0x80107a87
80103d62:	e8 19 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	68 79 7a 10 80       	push   $0x80107a79
80103d6f:	e8 0c c6 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 6d 7a 10 80       	push   $0x80107a6d
80103d7c:	e8 ff c5 ff ff       	call   80100380 <panic>
80103d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8f:	90                   	nop

80103d90 <exit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103d99:	e8 d2 fb ff ff       	call   80103970 <myproc>
  if(curproc == initproc)
80103d9e:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103da4:	0f 84 fd 00 00 00    	je     80103ea7 <exit+0x117>
80103daa:	89 c3                	mov    %eax,%ebx
80103dac:	8d 70 28             	lea    0x28(%eax),%esi
80103daf:	8d 78 68             	lea    0x68(%eax),%edi
80103db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103db8:	8b 06                	mov    (%esi),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 12                	je     80103dd0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	50                   	push   %eax
80103dc2:	e8 29 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103dc7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dcd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103dd0:	83 c6 04             	add    $0x4,%esi
80103dd3:	39 f7                	cmp    %esi,%edi
80103dd5:	75 e1                	jne    80103db8 <exit+0x28>
  begin_op();
80103dd7:	e8 84 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103ddc:	83 ec 0c             	sub    $0xc,%esp
80103ddf:	ff 73 68             	push   0x68(%ebx)
80103de2:	e8 c9 da ff ff       	call   801018b0 <iput>
  end_op();
80103de7:	e8 e4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103dec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103df3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103dfa:	e8 51 0a 00 00       	call   80104850 <acquire>
  wakeup1(curproc->parent);
80103dff:	8b 53 14             	mov    0x14(%ebx),%edx
80103e02:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e05:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e0a:	eb 0e                	jmp    80103e1a <exit+0x8a>
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e10:	83 e8 80             	sub    $0xffffff80,%eax
80103e13:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e18:	74 1c                	je     80103e36 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e1e:	75 f0                	jne    80103e10 <exit+0x80>
80103e20:	3b 50 20             	cmp    0x20(%eax),%edx
80103e23:	75 eb                	jne    80103e10 <exit+0x80>
      p->state = RUNNABLE;
80103e25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 e8 80             	sub    $0xffffff80,%eax
80103e2f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e34:	75 e4                	jne    80103e1a <exit+0x8a>
      p->parent = initproc;
80103e36:	8b 0d 54 3d 11 80    	mov    0x80113d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e41:	eb 10                	jmp    80103e53 <exit+0xc3>
80103e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e47:	90                   	nop
80103e48:	83 ea 80             	sub    $0xffffff80,%edx
80103e4b:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80103e51:	74 3b                	je     80103e8e <exit+0xfe>
    if(p->parent == curproc){
80103e53:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e56:	75 f0                	jne    80103e48 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e58:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e5c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e5f:	75 e7                	jne    80103e48 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e61:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e66:	eb 12                	jmp    80103e7a <exit+0xea>
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop
80103e70:	83 e8 80             	sub    $0xffffff80,%eax
80103e73:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e78:	74 ce                	je     80103e48 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <exit+0xe0>
80103e80:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e83:	75 eb                	jne    80103e70 <exit+0xe0>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e8c:	eb e2                	jmp    80103e70 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e8e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103e95:	e8 36 fe ff ff       	call   80103cd0 <sched>
  panic("zombie exit");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 a8 7a 10 80       	push   $0x80107aa8
80103ea2:	e8 d9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	68 9b 7a 10 80       	push   $0x80107a9b
80103eaf:	e8 cc c4 ff ff       	call   80100380 <panic>
80103eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop

80103ec0 <wait>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 36 08 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103eca:	e8 21 fa ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ecf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed5:	e8 76 08 00 00       	call   80104750 <popcli>
  acquire(&ptable.lock);
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 1d 11 80       	push   $0x80111d20
80103ee2:	e8 69 09 00 00       	call   80104850 <acquire>
80103ee7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103ef1:	eb 10                	jmp    80103f03 <wait+0x43>
80103ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef7:	90                   	nop
80103ef8:	83 eb 80             	sub    $0xffffff80,%ebx
80103efb:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f01:	74 1b                	je     80103f1e <wait+0x5e>
      if(p->parent != curproc)
80103f03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f06:	75 f0                	jne    80103ef8 <wait+0x38>
      if(p->state == ZOMBIE){
80103f08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f0c:	74 62                	je     80103f70 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103f11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f1c:	75 e5                	jne    80103f03 <wait+0x43>
    if(!havekids || curproc->killed){
80103f1e:	85 c0                	test   %eax,%eax
80103f20:	0f 84 a0 00 00 00    	je     80103fc6 <wait+0x106>
80103f26:	8b 46 24             	mov    0x24(%esi),%eax
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	0f 85 95 00 00 00    	jne    80103fc6 <wait+0x106>
  pushcli();
80103f31:	e8 ca 07 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103f36:	e8 b5 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f41:	e8 0a 08 00 00       	call   80104750 <popcli>
  if(p == 0)
80103f46:	85 db                	test   %ebx,%ebx
80103f48:	0f 84 8f 00 00 00    	je     80103fdd <wait+0x11d>
  p->chan = chan;
80103f4e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f51:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f58:	e8 73 fd ff ff       	call   80103cd0 <sched>
  p->chan = 0;
80103f5d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f64:	eb 84                	jmp    80103eea <wait+0x2a>
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f70:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f73:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f76:	ff 73 08             	push   0x8(%ebx)
80103f79:	e8 42 e5 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103f7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f85:	5a                   	pop    %edx
80103f86:	ff 73 04             	push   0x4(%ebx)
80103f89:	e8 72 31 00 00       	call   80107100 <freevm>
        p->pid = 0;
80103f8e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f95:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f9c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fa0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fa7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fae:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fb5:	e8 36 08 00 00       	call   801047f0 <release>
        return pid;
80103fba:	83 c4 10             	add    $0x10,%esp
}
80103fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc0:	89 f0                	mov    %esi,%eax
80103fc2:	5b                   	pop    %ebx
80103fc3:	5e                   	pop    %esi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
      release(&ptable.lock);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fc9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fce:	68 20 1d 11 80       	push   $0x80111d20
80103fd3:	e8 18 08 00 00       	call   801047f0 <release>
      return -1;
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb e0                	jmp    80103fbd <wait+0xfd>
    panic("sleep");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 b4 7a 10 80       	push   $0x80107ab4
80103fe5:	e8 96 c3 ff ff       	call   80100380 <panic>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ff0 <yield>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ff7:	68 20 1d 11 80       	push   $0x80111d20
80103ffc:	e8 4f 08 00 00       	call   80104850 <acquire>
  pushcli();
80104001:	e8 fa 06 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104006:	e8 e5 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
8010400b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104011:	e8 3a 07 00 00       	call   80104750 <popcli>
  myproc()->state = RUNNABLE;
80104016:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010401d:	e8 ae fc ff ff       	call   80103cd0 <sched>
  release(&ptable.lock);
80104022:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104029:	e8 c2 07 00 00       	call   801047f0 <release>
}
8010402e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104031:	83 c4 10             	add    $0x10,%esp
80104034:	c9                   	leave  
80104035:	c3                   	ret    
80104036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <sleep>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	8b 7d 08             	mov    0x8(%ebp),%edi
8010404c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010404f:	e8 ac 06 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104054:	e8 97 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104059:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010405f:	e8 ec 06 00 00       	call   80104750 <popcli>
  if(p == 0)
80104064:	85 db                	test   %ebx,%ebx
80104066:	0f 84 87 00 00 00    	je     801040f3 <sleep+0xb3>
  if(lk == 0)
8010406c:	85 f6                	test   %esi,%esi
8010406e:	74 76                	je     801040e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104070:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104076:	74 50                	je     801040c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 20 1d 11 80       	push   $0x80111d20
80104080:	e8 cb 07 00 00       	call   80104850 <acquire>
    release(lk);
80104085:	89 34 24             	mov    %esi,(%esp)
80104088:	e8 63 07 00 00       	call   801047f0 <release>
  p->chan = chan;
8010408d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104090:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104097:	e8 34 fc ff ff       	call   80103cd0 <sched>
  p->chan = 0;
8010409c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040a3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040aa:	e8 41 07 00 00       	call   801047f0 <release>
    acquire(lk);
801040af:	89 75 08             	mov    %esi,0x8(%ebp)
801040b2:	83 c4 10             	add    $0x10,%esp
}
801040b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b8:	5b                   	pop    %ebx
801040b9:	5e                   	pop    %esi
801040ba:	5f                   	pop    %edi
801040bb:	5d                   	pop    %ebp
    acquire(lk);
801040bc:	e9 8f 07 00 00       	jmp    80104850 <acquire>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 f9 fb ff ff       	call   80103cd0 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
    panic("sleep without lk");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 ba 7a 10 80       	push   $0x80107aba
801040ee:	e8 8d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	68 b4 7a 10 80       	push   $0x80107ab4
801040fb:	e8 80 c2 ff ff       	call   80100380 <panic>

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410a:	68 20 1d 11 80       	push   $0x80111d20
8010410f:	e8 3c 07 00 00       	call   80104850 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104117:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010411c:	eb 0c                	jmp    8010412a <wakeup+0x2a>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	83 e8 80             	sub    $0xffffff80,%eax
80104123:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104128:	74 1c                	je     80104146 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010412e:	75 f0                	jne    80104120 <wakeup+0x20>
80104130:	3b 58 20             	cmp    0x20(%eax),%ebx
80104133:	75 eb                	jne    80104120 <wakeup+0x20>
      p->state = RUNNABLE;
80104135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413c:	83 e8 80             	sub    $0xffffff80,%eax
8010413f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104144:	75 e4                	jne    8010412a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104146:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010414d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104150:	c9                   	leave  
  release(&ptable.lock);
80104151:	e9 9a 06 00 00       	jmp    801047f0 <release>
80104156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415d:	8d 76 00             	lea    0x0(%esi),%esi

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416a:	68 20 1d 11 80       	push   $0x80111d20
8010416f:	e8 dc 06 00 00       	call   80104850 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104177:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010417c:	eb 0c                	jmp    8010418a <kill+0x2a>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	83 e8 80             	sub    $0xffffff80,%eax
80104183:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104188:	74 36                	je     801041c0 <kill+0x60>
    if(p->pid == pid){
8010418a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010418d:	75 f1                	jne    80104180 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010418f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104193:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010419a:	75 07                	jne    801041a3 <kill+0x43>
        p->state = RUNNABLE;
8010419c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 20 1d 11 80       	push   $0x80111d20
801041ab:	e8 40 06 00 00       	call   801047f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041b3:	83 c4 10             	add    $0x10,%esp
801041b6:	31 c0                	xor    %eax,%eax
}
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 20 1d 11 80       	push   $0x80111d20
801041c8:	e8 23 06 00 00       	call   801047f0 <release>
}
801041cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041e8:	53                   	push   %ebx
801041e9:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801041ee:	83 ec 3c             	sub    $0x3c,%esp
801041f1:	eb 24                	jmp    80104217 <procdump+0x37>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 9f 7e 10 80       	push   $0x80107e9f
80104200:	e8 9b c4 ff ff       	call   801006a0 <cprintf>
80104205:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104208:	83 eb 80             	sub    $0xffffff80,%ebx
8010420b:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104211:	0f 84 81 00 00 00    	je     80104298 <procdump+0xb8>
    if(p->state == UNUSED)
80104217:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 ea                	je     80104208 <procdump+0x28>
      state = "???";
8010421e:	ba cb 7a 10 80       	mov    $0x80107acb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104223:	83 f8 05             	cmp    $0x5,%eax
80104226:	77 11                	ja     80104239 <procdump+0x59>
80104228:	8b 14 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%edx
      state = "???";
8010422f:	b8 cb 7a 10 80       	mov    $0x80107acb,%eax
80104234:	85 d2                	test   %edx,%edx
80104236:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104239:	53                   	push   %ebx
8010423a:	52                   	push   %edx
8010423b:	ff 73 a4             	push   -0x5c(%ebx)
8010423e:	68 cf 7a 10 80       	push   $0x80107acf
80104243:	e8 58 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104248:	83 c4 10             	add    $0x10,%esp
8010424b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010424f:	75 a7                	jne    801041f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104251:	83 ec 08             	sub    $0x8,%esp
80104254:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104257:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010425a:	50                   	push   %eax
8010425b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010425e:	8b 40 0c             	mov    0xc(%eax),%eax
80104261:	83 c0 08             	add    $0x8,%eax
80104264:	50                   	push   %eax
80104265:	e8 36 04 00 00       	call   801046a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010426a:	83 c4 10             	add    $0x10,%esp
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
80104270:	8b 17                	mov    (%edi),%edx
80104272:	85 d2                	test   %edx,%edx
80104274:	74 82                	je     801041f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104276:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104279:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010427c:	52                   	push   %edx
8010427d:	68 21 75 10 80       	push   $0x80107521
80104282:	e8 19 c4 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	39 fe                	cmp    %edi,%esi
8010428c:	75 e2                	jne    80104270 <procdump+0x90>
8010428e:	e9 65 ff ff ff       	jmp    801041f8 <procdump+0x18>
80104293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104297:	90                   	nop
  }
}
80104298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429b:	5b                   	pop    %ebx
8010429c:	5e                   	pop    %esi
8010429d:	5f                   	pop    %edi
8010429e:	5d                   	pop    %ebp
8010429f:	c3                   	ret    

801042a0 <clone>:

int
clone(void (*fn_ptr) (void* , void*), void *arg1, void *arg2, void *stack_ptr)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042a9:	e8 52 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
801042ae:	e8 3d f6 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
801042b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042b9:	e8 92 04 00 00       	call   80104750 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  //checks for unaligned page size address or address more than page processes assigned pages
  cprintf("addr of stack = %x current_process addr = %x\n" , stack_ptr , curproc->sz);
801042be:	83 ec 04             	sub    $0x4,%esp
801042c1:	ff 33                	push   (%ebx)
801042c3:	ff 75 14             	push   0x14(%ebp)
801042c6:	68 2c 7b 10 80       	push   $0x80107b2c
801042cb:	e8 d0 c3 ff ff       	call   801006a0 <cprintf>
  if ( (uint) stack_ptr % PGSIZE != 0) {
801042d0:	83 c4 10             	add    $0x10,%esp
801042d3:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
801042da:	0f 85 03 01 00 00    	jne    801043e3 <clone+0x143>
    return -1;
  }

  if ((uint) stack_ptr + PGSIZE > (curproc->sz))
801042e0:	8b 45 14             	mov    0x14(%ebp),%eax
801042e3:	05 00 10 00 00       	add    $0x1000,%eax
801042e8:	3b 03                	cmp    (%ebx),%eax
801042ea:	0f 87 f3 00 00 00    	ja     801043e3 <clone+0x143>
  {
    return -1;
  }

  // Allocate process.
  if((np = allocproc()) == 0){
801042f0:	e8 bb f4 ff ff       	call   801037b0 <allocproc>
801042f5:	89 c2                	mov    %eax,%edx
801042f7:	85 c0                	test   %eax,%eax
801042f9:	0f 84 e4 00 00 00    	je     801043e3 <clone+0x143>
    return -1;
  }

  // Copy process state from proc - No need to copy instead point to same pgdir
  np->pgdir =  curproc->pgdir;
801042ff:	8b 43 04             	mov    0x4(%ebx),%eax

  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
80104302:	8b 7a 18             	mov    0x18(%edx),%edi
80104305:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->pgdir =  curproc->pgdir;
8010430a:	89 42 04             	mov    %eax,0x4(%edx)
  np->sz = curproc->sz;
8010430d:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
8010430f:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80104312:	89 02                	mov    %eax,(%edx)

  //PRH : added 3b
  np->thread_stack = stack_ptr;
80104314:	8b 45 14             	mov    0x14(%ebp),%eax
  *np->tf = *curproc->tf;
80104317:	8b 73 18             	mov    0x18(%ebx),%esi
8010431a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->thread_stack = stack_ptr;
8010431c:	89 42 7c             	mov    %eax,0x7c(%edx)

  //Push return address - fake one , arg1 , arg2

  uint *arg2_st ;
  arg2_st = stack_ptr + PGSIZE - 1 * sizeof(uint) ;
  *(uint*) arg2_st = (uint) arg2;
8010431f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  np->tf->eip = (uint)fn_ptr;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104322:	31 f6                	xor    %esi,%esi
  *(uint*) arg2_st = (uint) arg2;
80104324:	8b 45 10             	mov    0x10(%ebp),%eax
  for(i = 0; i < NOFILE; i++)
80104327:	89 d7                	mov    %edx,%edi
  *(uint*) sret_stack = 0xffffff;
80104329:	c7 81 f4 0f 00 00 ff 	movl   $0xffffff,0xff4(%ecx)
80104330:	ff ff 00 
  *(uint*) arg2_st = (uint) arg2;
80104333:	89 81 fc 0f 00 00    	mov    %eax,0xffc(%ecx)
  *(uint*) arg1_st = (uint) arg1;
80104339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433c:	89 81 f8 0f 00 00    	mov    %eax,0xff8(%ecx)
  *(uint*) sret_stack = 0xffffff;
80104342:	89 c8                	mov    %ecx,%eax
  np->tf->esp = (uint)stack_ptr + PGSIZE - 3 * sizeof(uint);
80104344:	8b 4a 18             	mov    0x18(%edx),%ecx
80104347:	05 f4 0f 00 00       	add    $0xff4,%eax
8010434c:	89 41 44             	mov    %eax,0x44(%ecx)
  np->tf->eip = (uint)fn_ptr;
8010434f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104352:	8b 42 18             	mov    0x18(%edx),%eax
80104355:	89 48 38             	mov    %ecx,0x38(%eax)
  np->tf->eax = 0;
80104358:	8b 42 18             	mov    0x18(%edx),%eax
8010435b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104368:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010436c:	85 c0                	test   %eax,%eax
8010436e:	74 10                	je     80104380 <clone+0xe0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	50                   	push   %eax
80104374:	e8 27 cb ff ff       	call   80100ea0 <filedup>
80104379:	83 c4 10             	add    $0x10,%esp
8010437c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104380:	83 c6 01             	add    $0x1,%esi
80104383:	83 fe 10             	cmp    $0x10,%esi
80104386:	75 e0                	jne    80104368 <clone+0xc8>
  np->cwd = idup(curproc->cwd);
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	ff 73 68             	push   0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010438e:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104391:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104394:	e8 b7 d3 ff ff       	call   80101750 <idup>
80104399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010439c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010439f:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043a2:	8d 42 6c             	lea    0x6c(%edx),%eax
801043a5:	6a 10                	push   $0x10
801043a7:	53                   	push   %ebx
801043a8:	50                   	push   %eax
801043a9:	e8 22 07 00 00       	call   80104ad0 <safestrcpy>

  pid = np->pid;
801043ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043b1:	8b 5a 10             	mov    0x10(%edx),%ebx

  acquire(&ptable.lock);
801043b4:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801043bb:	e8 90 04 00 00       	call   80104850 <acquire>

  np->state = RUNNABLE;
801043c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043c3:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

  release(&ptable.lock);
801043ca:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801043d1:	e8 1a 04 00 00       	call   801047f0 <release>

  return pid;
801043d6:	83 c4 10             	add    $0x10,%esp
}
801043d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043dc:	89 d8                	mov    %ebx,%eax
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
    return -1;
801043e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043e8:	eb ef                	jmp    801043d9 <clone+0x139>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <join>:

int
join(void **stack)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801043fc:	e8 ff 02 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104401:	e8 ea f4 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104406:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010440c:	e8 3f 03 00 00       	call   80104750 <popcli>

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  if ((uint) stack + PGSIZE > (curproc->sz))
80104411:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
80104417:	3b 06                	cmp    (%esi),%eax
80104419:	0f 87 19 01 00 00    	ja     80104538 <join+0x148>
  {
    return -1;
  }

  if ((uint) stack < (curproc->tf->ebp))
8010441f:	8b 46 18             	mov    0x18(%esi),%eax
80104422:	3b 78 08             	cmp    0x8(%eax),%edi
80104425:	0f 82 0d 01 00 00    	jb     80104538 <join+0x148>
  {
    return -1;
  }
  
  acquire(&ptable.lock);
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	68 20 1d 11 80       	push   $0x80111d20
80104433:	e8 18 04 00 00       	call   80104850 <acquire>
80104438:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010443b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010443d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104442:	eb 0f                	jmp    80104453 <join+0x63>
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	83 eb 80             	sub    $0xffffff80,%ebx
8010444b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80104451:	74 1b                	je     8010446e <join+0x7e>
      if(p->parent != curproc)
80104453:	39 73 14             	cmp    %esi,0x14(%ebx)
80104456:	75 f0                	jne    80104448 <join+0x58>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104458:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010445c:	74 62                	je     801044c0 <join+0xd0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104461:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104466:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
8010446c:	75 e5                	jne    80104453 <join+0x63>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010446e:	85 c0                	test   %eax,%eax
80104470:	0f 84 ab 00 00 00    	je     80104521 <join+0x131>
80104476:	8b 46 24             	mov    0x24(%esi),%eax
80104479:	85 c0                	test   %eax,%eax
8010447b:	0f 85 a0 00 00 00    	jne    80104521 <join+0x131>
  pushcli();
80104481:	e8 7a 02 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104486:	e8 65 f4 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
8010448b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104491:	e8 ba 02 00 00       	call   80104750 <popcli>
  if(p == 0)
80104496:	85 db                	test   %ebx,%ebx
80104498:	0f 84 a1 00 00 00    	je     8010453f <join+0x14f>
  p->chan = chan;
8010449e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801044a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044a8:	e8 23 f8 ff ff       	call   80103cd0 <sched>
  p->chan = 0;
801044ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044b4:	eb 85                	jmp    8010443b <join+0x4b>
801044b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("Found a zombie nd thread stack: %x\n", p->thread_stack);
801044c0:	83 ec 08             	sub    $0x8,%esp
801044c3:	ff 73 7c             	push   0x7c(%ebx)
801044c6:	68 5c 7b 10 80       	push   $0x80107b5c
801044cb:	e8 d0 c1 ff ff       	call   801006a0 <cprintf>
        *stack = p->thread_stack;
801044d0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801044d3:	89 07                	mov    %eax,(%edi)
        kfree(p->kstack);
801044d5:	5a                   	pop    %edx
        pid = p->pid;
801044d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044d9:	ff 73 08             	push   0x8(%ebx)
801044dc:	e8 df df ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801044e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = 0;
801044e8:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044ef:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044f6:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044fa:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104501:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104508:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010450f:	e8 dc 02 00 00       	call   801047f0 <release>
        return pid;
80104514:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104517:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451a:	89 f0                	mov    %esi,%eax
8010451c:	5b                   	pop    %ebx
8010451d:	5e                   	pop    %esi
8010451e:	5f                   	pop    %edi
8010451f:	5d                   	pop    %ebp
80104520:	c3                   	ret    
      release(&ptable.lock);
80104521:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104524:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104529:	68 20 1d 11 80       	push   $0x80111d20
8010452e:	e8 bd 02 00 00       	call   801047f0 <release>
      return -1;
80104533:	83 c4 10             	add    $0x10,%esp
80104536:	eb df                	jmp    80104517 <join+0x127>
    return -1;
80104538:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010453d:	eb d8                	jmp    80104517 <join+0x127>
    panic("sleep");
8010453f:	83 ec 0c             	sub    $0xc,%esp
80104542:	68 b4 7a 10 80       	push   $0x80107ab4
80104547:	e8 34 be ff ff       	call   80100380 <panic>
8010454c:	66 90                	xchg   %ax,%ax
8010454e:	66 90                	xchg   %ax,%ax

80104550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010455a:	68 98 7b 10 80       	push   $0x80107b98
8010455f:	8d 43 04             	lea    0x4(%ebx),%eax
80104562:	50                   	push   %eax
80104563:	e8 18 01 00 00       	call   80104680 <initlock>
  lk->name = name;
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010456b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010457b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010457e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104581:	c9                   	leave  
80104582:	c3                   	ret    
80104583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 ac 02 00 00       	call   80104850 <acquire>
  while (lk->locked) {
801045a4:	8b 13                	mov    (%ebx),%edx
801045a6:	83 c4 10             	add    $0x10,%esp
801045a9:	85 d2                	test   %edx,%edx
801045ab:	74 16                	je     801045c3 <acquiresleep+0x33>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	e8 86 fa ff ff       	call   80104040 <sleep>
  while (lk->locked) {
801045ba:	8b 03                	mov    (%ebx),%eax
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 ed                	jne    801045b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045c9:	e8 a2 f3 ff ff       	call   80103970 <myproc>
801045ce:	8b 40 10             	mov    0x10(%eax),%eax
801045d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045da:	5b                   	pop    %ebx
801045db:	5e                   	pop    %esi
801045dc:	5d                   	pop    %ebp
  release(&lk->lk);
801045dd:	e9 0e 02 00 00       	jmp    801047f0 <release>
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	8d 73 04             	lea    0x4(%ebx),%esi
801045fb:	83 ec 0c             	sub    $0xc,%esp
801045fe:	56                   	push   %esi
801045ff:	e8 4c 02 00 00       	call   80104850 <acquire>
  lk->locked = 0;
80104604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010460a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104611:	89 1c 24             	mov    %ebx,(%esp)
80104614:	e8 e7 fa ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
80104619:	89 75 08             	mov    %esi,0x8(%ebp)
8010461c:	83 c4 10             	add    $0x10,%esp
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
  release(&lk->lk);
80104625:	e9 c6 01 00 00       	jmp    801047f0 <release>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	31 ff                	xor    %edi,%edi
80104636:	56                   	push   %esi
80104637:	53                   	push   %ebx
80104638:	83 ec 18             	sub    $0x18,%esp
8010463b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010463e:	8d 73 04             	lea    0x4(%ebx),%esi
80104641:	56                   	push   %esi
80104642:	e8 09 02 00 00       	call   80104850 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104647:	8b 03                	mov    (%ebx),%eax
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	85 c0                	test   %eax,%eax
8010464e:	75 18                	jne    80104668 <holdingsleep+0x38>
  release(&lk->lk);
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	56                   	push   %esi
80104654:	e8 97 01 00 00       	call   801047f0 <release>
  return r;
}
80104659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010465c:	89 f8                	mov    %edi,%eax
8010465e:	5b                   	pop    %ebx
8010465f:	5e                   	pop    %esi
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104667:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104668:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010466b:	e8 00 f3 ff ff       	call   80103970 <myproc>
80104670:	39 58 10             	cmp    %ebx,0x10(%eax)
80104673:	0f 94 c0             	sete   %al
80104676:	0f b6 c0             	movzbl %al,%eax
80104679:	89 c7                	mov    %eax,%edi
8010467b:	eb d3                	jmp    80104650 <holdingsleep+0x20>
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104686:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010468f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046a1:	31 d2                	xor    %edx,%edx
{
801046a3:	89 e5                	mov    %esp,%ebp
801046a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046bc:	77 1a                	ja     801046d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046be:	8b 58 04             	mov    0x4(%eax),%ebx
801046c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046c9:	83 fa 0a             	cmp    $0xa,%edx
801046cc:	75 e2                	jne    801046b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave  
801046d2:	c3                   	ret    
801046d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d7:	90                   	nop
  for(; i < 10; i++)
801046d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046db:	8d 51 28             	lea    0x28(%ecx),%edx
801046de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046e6:	83 c0 04             	add    $0x4,%eax
801046e9:	39 d0                	cmp    %edx,%eax
801046eb:	75 f3                	jne    801046e0 <getcallerpcs+0x40>
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
80104707:	9c                   	pushf  
80104708:	5b                   	pop    %ebx
  asm volatile("cli");
80104709:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010470a:	e8 e1 f1 ff ff       	call   801038f0 <mycpu>
8010470f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104715:	85 c0                	test   %eax,%eax
80104717:	74 17                	je     80104730 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104719:	e8 d2 f1 ff ff       	call   801038f0 <mycpu>
8010471e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104730:	e8 bb f1 ff ff       	call   801038f0 <mycpu>
80104735:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010473b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104741:	eb d6                	jmp    80104719 <pushcli+0x19>
80104743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <popcli>:

void
popcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104756:	9c                   	pushf  
80104757:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104758:	f6 c4 02             	test   $0x2,%ah
8010475b:	75 35                	jne    80104792 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010475d:	e8 8e f1 ff ff       	call   801038f0 <mycpu>
80104762:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104769:	78 34                	js     8010479f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010476b:	e8 80 f1 ff ff       	call   801038f0 <mycpu>
80104770:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104776:	85 d2                	test   %edx,%edx
80104778:	74 06                	je     80104780 <popcli+0x30>
    sti();
}
8010477a:	c9                   	leave  
8010477b:	c3                   	ret    
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104780:	e8 6b f1 ff ff       	call   801038f0 <mycpu>
80104785:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010478b:	85 c0                	test   %eax,%eax
8010478d:	74 eb                	je     8010477a <popcli+0x2a>
  asm volatile("sti");
8010478f:	fb                   	sti    
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    
    panic("popcli - interruptible");
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	68 a3 7b 10 80       	push   $0x80107ba3
8010479a:	e8 e1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010479f:	83 ec 0c             	sub    $0xc,%esp
801047a2:	68 ba 7b 10 80       	push   $0x80107bba
801047a7:	e8 d4 bb ff ff       	call   80100380 <panic>
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <holding>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 75 08             	mov    0x8(%ebp),%esi
801047b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ba:	e8 41 ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047bf:	8b 06                	mov    (%esi),%eax
801047c1:	85 c0                	test   %eax,%eax
801047c3:	75 0b                	jne    801047d0 <holding+0x20>
  popcli();
801047c5:	e8 86 ff ff ff       	call   80104750 <popcli>
}
801047ca:	89 d8                	mov    %ebx,%eax
801047cc:	5b                   	pop    %ebx
801047cd:	5e                   	pop    %esi
801047ce:	5d                   	pop    %ebp
801047cf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801047d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047d3:	e8 18 f1 ff ff       	call   801038f0 <mycpu>
801047d8:	39 c3                	cmp    %eax,%ebx
801047da:	0f 94 c3             	sete   %bl
  popcli();
801047dd:	e8 6e ff ff ff       	call   80104750 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047e2:	0f b6 db             	movzbl %bl,%ebx
}
801047e5:	89 d8                	mov    %ebx,%eax
801047e7:	5b                   	pop    %ebx
801047e8:	5e                   	pop    %esi
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    
801047eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop

801047f0 <release>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047f8:	e8 03 ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047fd:	8b 03                	mov    (%ebx),%eax
801047ff:	85 c0                	test   %eax,%eax
80104801:	75 15                	jne    80104818 <release+0x28>
  popcli();
80104803:	e8 48 ff ff ff       	call   80104750 <popcli>
    panic("release");
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	68 c1 7b 10 80       	push   $0x80107bc1
80104810:	e8 6b bb ff ff       	call   80100380 <panic>
80104815:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104818:	8b 73 08             	mov    0x8(%ebx),%esi
8010481b:	e8 d0 f0 ff ff       	call   801038f0 <mycpu>
80104820:	39 c6                	cmp    %eax,%esi
80104822:	75 df                	jne    80104803 <release+0x13>
  popcli();
80104824:	e8 27 ff ff ff       	call   80104750 <popcli>
  lk->pcs[0] = 0;
80104829:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104830:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104837:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010483c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104842:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5d                   	pop    %ebp
  popcli();
80104848:	e9 03 ff ff ff       	jmp    80104750 <popcli>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <acquire>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104857:	e8 a4 fe ff ff       	call   80104700 <pushcli>
  if(holding(lk))
8010485c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010485f:	e8 9c fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104864:	8b 03                	mov    (%ebx),%eax
80104866:	85 c0                	test   %eax,%eax
80104868:	75 7e                	jne    801048e8 <acquire+0x98>
  popcli();
8010486a:	e8 e1 fe ff ff       	call   80104750 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010486f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104878:	8b 55 08             	mov    0x8(%ebp),%edx
8010487b:	89 c8                	mov    %ecx,%eax
8010487d:	f0 87 02             	lock xchg %eax,(%edx)
80104880:	85 c0                	test   %eax,%eax
80104882:	75 f4                	jne    80104878 <acquire+0x28>
  __sync_synchronize();
80104884:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010488c:	e8 5f f0 ff ff       	call   801038f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104891:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104894:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104896:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104899:	31 c0                	xor    %eax,%eax
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ac:	77 1a                	ja     801048c8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801048b1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048b5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048b8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048ba:	83 f8 0a             	cmp    $0xa,%eax
801048bd:	75 e1                	jne    801048a0 <acquire+0x50>
}
801048bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c2:	c9                   	leave  
801048c3:	c3                   	ret    
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048c8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048cc:	8d 51 34             	lea    0x34(%ecx),%edx
801048cf:	90                   	nop
    pcs[i] = 0;
801048d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048d6:	83 c0 04             	add    $0x4,%eax
801048d9:	39 c2                	cmp    %eax,%edx
801048db:	75 f3                	jne    801048d0 <acquire+0x80>
}
801048dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e0:	c9                   	leave  
801048e1:	c3                   	ret    
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048e8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048eb:	e8 00 f0 ff ff       	call   801038f0 <mycpu>
801048f0:	39 c3                	cmp    %eax,%ebx
801048f2:	0f 85 72 ff ff ff    	jne    8010486a <acquire+0x1a>
  popcli();
801048f8:	e8 53 fe ff ff       	call   80104750 <popcli>
    panic("acquire");
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	68 c9 7b 10 80       	push   $0x80107bc9
80104905:	e8 76 ba ff ff       	call   80100380 <panic>
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 55 08             	mov    0x8(%ebp),%edx
80104917:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491a:	53                   	push   %ebx
8010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010491e:	89 d7                	mov    %edx,%edi
80104920:	09 cf                	or     %ecx,%edi
80104922:	83 e7 03             	and    $0x3,%edi
80104925:	75 29                	jne    80104950 <memset+0x40>
    c &= 0xFF;
80104927:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010492a:	c1 e0 18             	shl    $0x18,%eax
8010492d:	89 fb                	mov    %edi,%ebx
8010492f:	c1 e9 02             	shr    $0x2,%ecx
80104932:	c1 e3 10             	shl    $0x10,%ebx
80104935:	09 d8                	or     %ebx,%eax
80104937:	09 f8                	or     %edi,%eax
80104939:	c1 e7 08             	shl    $0x8,%edi
8010493c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010493e:	89 d7                	mov    %edx,%edi
80104940:	fc                   	cld    
80104941:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104943:	5b                   	pop    %ebx
80104944:	89 d0                	mov    %edx,%eax
80104946:	5f                   	pop    %edi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104950:	89 d7                	mov    %edx,%edi
80104952:	fc                   	cld    
80104953:	f3 aa                	rep stos %al,%es:(%edi)
80104955:	5b                   	pop    %ebx
80104956:	89 d0                	mov    %edx,%eax
80104958:	5f                   	pop    %edi
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop

80104960 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 75 10             	mov    0x10(%ebp),%esi
80104967:	8b 55 08             	mov    0x8(%ebp),%edx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010496e:	85 f6                	test   %esi,%esi
80104970:	74 2e                	je     801049a0 <memcmp+0x40>
80104972:	01 c6                	add    %eax,%esi
80104974:	eb 14                	jmp    8010498a <memcmp+0x2a>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104986:	39 f0                	cmp    %esi,%eax
80104988:	74 16                	je     801049a0 <memcmp+0x40>
    if(*s1 != *s2)
8010498a:	0f b6 0a             	movzbl (%edx),%ecx
8010498d:	0f b6 18             	movzbl (%eax),%ebx
80104990:	38 d9                	cmp    %bl,%cl
80104992:	74 ec                	je     80104980 <memcmp+0x20>
      return *s1 - *s2;
80104994:	0f b6 c1             	movzbl %cl,%eax
80104997:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	5b                   	pop    %ebx
  return 0;
801049a1:	31 c0                	xor    %eax,%eax
}
801049a3:	5e                   	pop    %esi
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ba:	56                   	push   %esi
801049bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049be:	39 d6                	cmp    %edx,%esi
801049c0:	73 26                	jae    801049e8 <memmove+0x38>
801049c2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049c5:	39 fa                	cmp    %edi,%edx
801049c7:	73 1f                	jae    801049e8 <memmove+0x38>
801049c9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049cc:	85 c9                	test   %ecx,%ecx
801049ce:	74 0c                	je     801049dc <memmove+0x2c>
      *--d = *--s;
801049d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049d7:	83 e8 01             	sub    $0x1,%eax
801049da:	73 f4                	jae    801049d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049dc:	5e                   	pop    %esi
801049dd:	89 d0                	mov    %edx,%eax
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049e8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049eb:	89 d7                	mov    %edx,%edi
801049ed:	85 c9                	test   %ecx,%ecx
801049ef:	74 eb                	je     801049dc <memmove+0x2c>
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049f9:	39 c6                	cmp    %eax,%esi
801049fb:	75 fb                	jne    801049f8 <memmove+0x48>
}
801049fd:	5e                   	pop    %esi
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a10:	eb 9e                	jmp    801049b0 <memmove>
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 75 10             	mov    0x10(%ebp),%esi
80104a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a2a:	53                   	push   %ebx
80104a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a2e:	85 f6                	test   %esi,%esi
80104a30:	74 2e                	je     80104a60 <strncmp+0x40>
80104a32:	01 d6                	add    %edx,%esi
80104a34:	eb 18                	jmp    80104a4e <strncmp+0x2e>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	38 d8                	cmp    %bl,%al
80104a42:	75 14                	jne    80104a58 <strncmp+0x38>
    n--, p++, q++;
80104a44:	83 c2 01             	add    $0x1,%edx
80104a47:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a4a:	39 f2                	cmp    %esi,%edx
80104a4c:	74 12                	je     80104a60 <strncmp+0x40>
80104a4e:	0f b6 01             	movzbl (%ecx),%eax
80104a51:	0f b6 1a             	movzbl (%edx),%ebx
80104a54:	84 c0                	test   %al,%al
80104a56:	75 e8                	jne    80104a40 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a58:	29 d8                	sub    %ebx,%eax
}
80104a5a:	5b                   	pop    %ebx
80104a5b:	5e                   	pop    %esi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret    
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	5b                   	pop    %ebx
    return 0;
80104a61:	31 c0                	xor    %eax,%eax
}
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	8b 75 08             	mov    0x8(%ebp),%esi
80104a78:	53                   	push   %ebx
80104a79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a7c:	89 f0                	mov    %esi,%eax
80104a7e:	eb 15                	jmp    80104a95 <strncpy+0x25>
80104a80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a87:	83 c0 01             	add    $0x1,%eax
80104a8a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a8e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a91:	84 d2                	test   %dl,%dl
80104a93:	74 09                	je     80104a9e <strncpy+0x2e>
80104a95:	89 cb                	mov    %ecx,%ebx
80104a97:	83 e9 01             	sub    $0x1,%ecx
80104a9a:	85 db                	test   %ebx,%ebx
80104a9c:	7f e2                	jg     80104a80 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a9e:	89 c2                	mov    %eax,%edx
80104aa0:	85 c9                	test   %ecx,%ecx
80104aa2:	7e 17                	jle    80104abb <strncpy+0x4b>
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104aa8:	83 c2 01             	add    $0x1,%edx
80104aab:	89 c1                	mov    %eax,%ecx
80104aad:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104ab1:	29 d1                	sub    %edx,%ecx
80104ab3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ab7:	85 c9                	test   %ecx,%ecx
80104ab9:	7f ed                	jg     80104aa8 <strncpy+0x38>
  return os;
}
80104abb:	5b                   	pop    %ebx
80104abc:	89 f0                	mov    %esi,%eax
80104abe:	5e                   	pop    %esi
80104abf:	5f                   	pop    %edi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret    
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ad7:	8b 75 08             	mov    0x8(%ebp),%esi
80104ada:	53                   	push   %ebx
80104adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ade:	85 d2                	test   %edx,%edx
80104ae0:	7e 25                	jle    80104b07 <safestrcpy+0x37>
80104ae2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ae6:	89 f2                	mov    %esi,%edx
80104ae8:	eb 16                	jmp    80104b00 <safestrcpy+0x30>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104af0:	0f b6 08             	movzbl (%eax),%ecx
80104af3:	83 c0 01             	add    $0x1,%eax
80104af6:	83 c2 01             	add    $0x1,%edx
80104af9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104afc:	84 c9                	test   %cl,%cl
80104afe:	74 04                	je     80104b04 <safestrcpy+0x34>
80104b00:	39 d8                	cmp    %ebx,%eax
80104b02:	75 ec                	jne    80104af0 <safestrcpy+0x20>
    ;
  *s = 0;
80104b04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b07:	89 f0                	mov    %esi,%eax
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strlen>:

int
strlen(const char *s)
{
80104b10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b18:	80 3a 00             	cmpb   $0x0,(%edx)
80104b1b:	74 0c                	je     80104b29 <strlen+0x19>
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	83 c0 01             	add    $0x1,%eax
80104b23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b27:	75 f7                	jne    80104b20 <strlen+0x10>
    ;
  return n;
}
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    

80104b2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b33:	55                   	push   %ebp
  pushl %ebx
80104b34:	53                   	push   %ebx
  pushl %esi
80104b35:	56                   	push   %esi
  pushl %edi
80104b36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b3b:	5f                   	pop    %edi
  popl %esi
80104b3c:	5e                   	pop    %esi
  popl %ebx
80104b3d:	5b                   	pop    %ebx
  popl %ebp
80104b3e:	5d                   	pop    %ebp
  ret
80104b3f:	c3                   	ret    

80104b40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b4a:	e8 21 ee ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4f:	8b 00                	mov    (%eax),%eax
80104b51:	39 d8                	cmp    %ebx,%eax
80104b53:	76 1b                	jbe    80104b70 <fetchint+0x30>
80104b55:	8d 53 04             	lea    0x4(%ebx),%edx
80104b58:	39 d0                	cmp    %edx,%eax
80104b5a:	72 14                	jb     80104b70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5f:	8b 13                	mov    (%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b68:	c9                   	leave  
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb ee                	jmp    80104b65 <fetchint+0x25>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b8a:	e8 e1 ed ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz)
80104b8f:	39 18                	cmp    %ebx,(%eax)
80104b91:	76 2d                	jbe    80104bc0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b9a:	39 d3                	cmp    %edx,%ebx
80104b9c:	73 22                	jae    80104bc0 <fetchstr+0x40>
80104b9e:	89 d8                	mov    %ebx,%eax
80104ba0:	eb 0d                	jmp    80104baf <fetchstr+0x2f>
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ba8:	83 c0 01             	add    $0x1,%eax
80104bab:	39 c2                	cmp    %eax,%edx
80104bad:	76 11                	jbe    80104bc0 <fetchstr+0x40>
    if(*s == 0)
80104baf:	80 38 00             	cmpb   $0x0,(%eax)
80104bb2:	75 f4                	jne    80104ba8 <fetchstr+0x28>
      return s - *pp;
80104bb4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb9:	c9                   	leave  
80104bba:	c3                   	ret    
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
80104bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 96 ed ff ff       	call   80103970 <myproc>
80104bda:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdd:	8b 40 18             	mov    0x18(%eax),%eax
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 85 ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104beb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bee:	8b 00                	mov    (%eax),%eax
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 1c                	jae    80104c10 <argint+0x40>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 15                	jb     80104c10 <argint+0x40>
  *ip = *(int*)(addr);
80104bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	eb ee                	jmp    80104c05 <argint+0x35>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
80104c26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c29:	e8 42 ed ff ff       	call   80103970 <myproc>
80104c2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c30:	e8 3b ed ff ff       	call   80103970 <myproc>
80104c35:	8b 55 08             	mov    0x8(%ebp),%edx
80104c38:	8b 40 18             	mov    0x18(%eax),%eax
80104c3b:	8b 40 44             	mov    0x44(%eax),%eax
80104c3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c41:	e8 2a ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c49:	8b 00                	mov    (%eax),%eax
80104c4b:	39 c7                	cmp    %eax,%edi
80104c4d:	73 31                	jae    80104c80 <argptr+0x60>
80104c4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c52:	39 c8                	cmp    %ecx,%eax
80104c54:	72 2a                	jb     80104c80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c5c:	85 d2                	test   %edx,%edx
80104c5e:	78 20                	js     80104c80 <argptr+0x60>
80104c60:	8b 16                	mov    (%esi),%edx
80104c62:	39 c2                	cmp    %eax,%edx
80104c64:	76 1a                	jbe    80104c80 <argptr+0x60>
80104c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c69:	01 c3                	add    %eax,%ebx
80104c6b:	39 da                	cmp    %ebx,%edx
80104c6d:	72 11                	jb     80104c80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c72:	89 02                	mov    %eax,(%edx)
  return 0;
80104c74:	31 c0                	xor    %eax,%eax
}
80104c76:	83 c4 0c             	add    $0xc,%esp
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5f                   	pop    %edi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c85:	eb ef                	jmp    80104c76 <argptr+0x56>
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	e8 d6 ec ff ff       	call   80103970 <myproc>
80104c9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ca0:	8b 40 44             	mov    0x44(%eax),%eax
80104ca3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ca6:	e8 c5 ec ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cae:	8b 00                	mov    (%eax),%eax
80104cb0:	39 c6                	cmp    %eax,%esi
80104cb2:	73 44                	jae    80104cf8 <argstr+0x68>
80104cb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cb7:	39 d0                	cmp    %edx,%eax
80104cb9:	72 3d                	jb     80104cf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104cbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cbe:	e8 ad ec ff ff       	call   80103970 <myproc>
  if(addr >= curproc->sz)
80104cc3:	3b 18                	cmp    (%eax),%ebx
80104cc5:	73 31                	jae    80104cf8 <argstr+0x68>
  *pp = (char*)addr;
80104cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ccc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cce:	39 d3                	cmp    %edx,%ebx
80104cd0:	73 26                	jae    80104cf8 <argstr+0x68>
80104cd2:	89 d8                	mov    %ebx,%eax
80104cd4:	eb 11                	jmp    80104ce7 <argstr+0x57>
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	39 c2                	cmp    %eax,%edx
80104ce5:	76 11                	jbe    80104cf8 <argstr+0x68>
    if(*s == 0)
80104ce7:	80 38 00             	cmpb   $0x0,(%eax)
80104cea:	75 f4                	jne    80104ce0 <argstr+0x50>
      return s - *pp;
80104cec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cee:	5b                   	pop    %ebx
80104cef:	5e                   	pop    %esi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret    
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	5b                   	pop    %ebx
    return -1;
80104cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cfe:	5e                   	pop    %esi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <syscall>:
[SYS_join]  sys_join,
};

void
syscall(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d17:	e8 54 ec ff ff       	call   80103970 <myproc>
80104d1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d1e:	8b 40 18             	mov    0x18(%eax),%eax
80104d21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	83 fa 16             	cmp    $0x16,%edx
80104d2a:	77 24                	ja     80104d50 <syscall+0x40>
80104d2c:	8b 14 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	74 19                	je     80104d50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d37:	ff d2                	call   *%edx
80104d39:	89 c2                	mov    %eax,%edx
80104d3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d44:	c9                   	leave  
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d54:	50                   	push   %eax
80104d55:	ff 73 10             	push   0x10(%ebx)
80104d58:	68 d1 7b 10 80       	push   $0x80107bd1
80104d5d:	e8 3e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d62:	8b 43 18             	mov    0x18(%ebx),%eax
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    
80104d74:	66 90                	xchg   %ax,%ax
80104d76:	66 90                	xchg   %ax,%ax
80104d78:	66 90                	xchg   %ax,%ax
80104d7a:	66 90                	xchg   %ax,%ax
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d88:	53                   	push   %ebx
80104d89:	83 ec 34             	sub    $0x34,%esp
80104d8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	57                   	push   %edi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 21 d3 ff ff       	call   801020c0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 cb c9 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	6a 00                	push   $0x0
80104dba:	57                   	push   %edi
80104dbb:	53                   	push   %ebx
80104dbc:	e8 1f cf ff ff       	call   80101ce0 <dirlookup>
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	89 c6                	mov    %eax,%esi
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	74 56                	je     80104e20 <create+0xa0>
    iunlockput(dp);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	53                   	push   %ebx
80104dce:	e8 3d cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104dd3:	89 34 24             	mov    %esi,(%esp)
80104dd6:	e8 a5 c9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddb:	83 c4 10             	add    $0x10,%esp
80104dde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104de3:	75 1b                	jne    80104e00 <create+0x80>
80104de5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dea:	75 14                	jne    80104e00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104def:	89 f0                	mov    %esi,%eax
80104df1:	5b                   	pop    %ebx
80104df2:	5e                   	pop    %esi
80104df3:	5f                   	pop    %edi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	56                   	push   %esi
    return 0;
80104e04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e06:	e8 05 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e11:	89 f0                	mov    %esi,%eax
80104e13:	5b                   	pop    %ebx
80104e14:	5e                   	pop    %esi
80104e15:	5f                   	pop    %edi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret    
80104e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	50                   	push   %eax
80104e28:	ff 33                	push   (%ebx)
80104e2a:	e8 e1 c7 ff ff       	call   80101610 <ialloc>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	89 c6                	mov    %eax,%esi
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 cd 00 00 00    	je     80104f09 <create+0x189>
  ilock(ip);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	50                   	push   %eax
80104e40:	e8 3b c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104e45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e55:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e5e:	89 34 24             	mov    %esi,(%esp)
80104e61:	e8 6a c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e6e:	74 30                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	ff 76 04             	push   0x4(%esi)
80104e76:	57                   	push   %edi
80104e77:	53                   	push   %ebx
80104e78:	e8 63 d1 ff ff       	call   80101fe0 <dirlink>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 78                	js     80104efc <create+0x17c>
  iunlockput(dp);
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	53                   	push   %ebx
80104e88:	e8 83 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e93:	89 f0                	mov    %esi,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5f                   	pop    %edi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret    
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ea3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea8:	53                   	push   %ebx
80104ea9:	e8 22 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 76 04             	push   0x4(%esi)
80104eb4:	68 7c 7c 10 80       	push   $0x80107c7c
80104eb9:	56                   	push   %esi
80104eba:	e8 21 d1 ff ff       	call   80101fe0 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 18                	js     80104ede <create+0x15e>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	push   0x4(%ebx)
80104ecc:	68 7b 7c 10 80       	push   $0x80107c7b
80104ed1:	56                   	push   %esi
80104ed2:	e8 09 d1 ff ff       	call   80101fe0 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	79 92                	jns    80104e70 <create+0xf0>
      panic("create dots");
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	68 6f 7c 10 80       	push   $0x80107c6f
80104ee6:	e8 95 b4 ff ff       	call   80100380 <panic>
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ef3:	31 f6                	xor    %esi,%esi
}
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 f0                	mov    %esi,%eax
80104ef8:	5e                   	pop    %esi
80104ef9:	5f                   	pop    %edi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
    panic("create: dirlink");
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	68 7e 7c 10 80       	push   $0x80107c7e
80104f04:	e8 77 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 60 7c 10 80       	push   $0x80107c60
80104f11:	e8 6a b4 ff ff       	call   80100380 <panic>
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <sys_dup>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 9d fc ff ff       	call   80104bd0 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 36                	js     80104f70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 30                	ja     80104f70 <sys_dup+0x50>
80104f40:	e8 2b ea ff ff       	call   80103970 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 20                	je     80104f70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f50:	e8 1b ea ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 18                	je     80104f80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_dup+0x40>
}
80104f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	5b                   	pop    %ebx
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f83:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f87:	56                   	push   %esi
80104f88:	e8 13 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret    
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 1d fc ff ff       	call   80104bd0 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_read+0x78>
80104fc0:	e8 ab e9 ff ff       	call   80103970 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 f2 fb ff ff       	call   80104bd0 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_read+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 2d fc ff ff       	call   80104c20 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_read+0x78>
  return fileread(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 17 c0 ff ff       	call   80101020 <fileread>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105017:	90                   	nop
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_read+0x6c>
8010501f:	90                   	nop

80105020 <sys_write>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 9d fb ff ff       	call   80104bd0 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_write+0x78>
80105040:	e8 2b e9 ff ff       	call   80103970 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 72 fb ff ff       	call   80104bd0 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_write+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	push   -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 ad fb ff ff       	call   80104c20 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_write+0x78>
  return filewrite(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	push   -0x10(%ebp)
80105080:	ff 75 f4             	push   -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 27 c0 ff ff       	call   801010b0 <filewrite>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105097:	90                   	nop
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_write+0x6c>
8010509f:	90                   	nop

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	50                   	push   %eax
801050ac:	6a 00                	push   $0x0
801050ae:	e8 1d fb ff ff       	call   80104bd0 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 3e                	js     801050f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 38                	ja     801050f8 <sys_close+0x58>
801050c0:	e8 ab e8 ff ff       	call   80103970 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050cf:	85 f6                	test   %esi,%esi
801050d1:	74 25                	je     801050f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050d3:	e8 98 e8 ff ff       	call   80103970 <myproc>
  fileclose(f);
801050d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050e2:	00 
  fileclose(f);
801050e3:	56                   	push   %esi
801050e4:	e8 07 be ff ff       	call   80100ef0 <fileclose>
  return 0;
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret    
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <sys_close+0x4e>
801050ff:	90                   	nop

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 bd fa ff ff       	call   80104bd0 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 46                	js     80105160 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 40                	ja     80105160 <sys_fstat+0x60>
80105120:	e8 4b e8 ff ff       	call   80103970 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 30                	je     80105160 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	6a 14                	push   $0x14
80105135:	53                   	push   %ebx
80105136:	6a 01                	push   $0x1
80105138:	e8 e3 fa ff ff       	call   80104c20 <argptr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 1c                	js     80105160 <sys_fstat+0x60>
  return filestat(f, st);
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	ff 75 f4             	push   -0xc(%ebp)
8010514a:	56                   	push   %esi
8010514b:	e8 80 be ff ff       	call   80100fd0 <filestat>
80105150:	83 c4 10             	add    $0x10,%esp
}
80105153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105156:	5b                   	pop    %ebx
80105157:	5e                   	pop    %esi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ec                	jmp    80105153 <sys_fstat+0x53>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105175:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 0c fb ff ff       	call   80104c90 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 f3 fa ff ff       	call   80104c90 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 b3 db ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	push   -0x2c(%ebp)
801051b3:	e8 e8 ce ff ff       	call   801020a0 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	89 c3                	mov    %eax,%ebx
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 e4 00 00 00    	je     801052a9 <sys_link+0x139>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 b2 c5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 b5 00 00 00    	je     80105291 <sys_link+0x121>
  iupdate(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 e3 c4 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 6b c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	push   -0x30(%ebp)
801051fb:	e8 c0 ce ff ff       	call   801020c0 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	89 c6                	mov    %eax,%esi
80105205:	85 c0                	test   %eax,%eax
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 6e c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	8b 03                	mov    (%ebx),%eax
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	push   0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 b8 cd ff ff       	call   80101fe0 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 d8 c7 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 70 c6 ff ff       	call   801018b0 <iput>
  end_op();
80105240:	e8 8b db ff ff       	call   80102dd0 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 af c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 13 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 56 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 8e c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105282:	e8 49 db ff ff       	call   80102dd0 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb b9                	jmp    8010524a <sys_link+0xda>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 76 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010529a:	e8 31 db ff ff       	call   80102dd0 <end_op>
    return -1;
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a7:	eb a1                	jmp    8010524a <sys_link+0xda>
    end_op();
801052a9:	e8 22 db ff ff       	call   80102dd0 <end_op>
    return -1;
801052ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b3:	eb 95                	jmp    8010524a <sys_link+0xda>
801052b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_unlink>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 bc f9 ff ff       	call   80104c90 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 7a 01 00 00    	js     80105459 <sys_unlink+0x199>
  begin_op();
801052df:	e8 7c da ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	53                   	push   %ebx
801052eb:	ff 75 c0             	push   -0x40(%ebp)
801052ee:	e8 cd cd ff ff       	call   801020c0 <nameiparent>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 62 01 00 00    	je     80105463 <sys_unlink+0x1a3>
  ilock(dp);
80105301:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	57                   	push   %edi
80105308:	e8 73 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010530d:	58                   	pop    %eax
8010530e:	5a                   	pop    %edx
8010530f:	68 7c 7c 10 80       	push   $0x80107c7c
80105314:	53                   	push   %ebx
80105315:	e8 a6 c9 ff ff       	call   80101cc0 <namecmp>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	0f 84 fb 00 00 00    	je     80105420 <sys_unlink+0x160>
80105325:	83 ec 08             	sub    $0x8,%esp
80105328:	68 7b 7c 10 80       	push   $0x80107c7b
8010532d:	53                   	push   %ebx
8010532e:	e8 8d c9 ff ff       	call   80101cc0 <namecmp>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	0f 84 e2 00 00 00    	je     80105420 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533e:	83 ec 04             	sub    $0x4,%esp
80105341:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105344:	50                   	push   %eax
80105345:	53                   	push   %ebx
80105346:	57                   	push   %edi
80105347:	e8 94 c9 ff ff       	call   80101ce0 <dirlookup>
8010534c:	83 c4 10             	add    $0x10,%esp
8010534f:	89 c3                	mov    %eax,%ebx
80105351:	85 c0                	test   %eax,%eax
80105353:	0f 84 c7 00 00 00    	je     80105420 <sys_unlink+0x160>
  ilock(ip);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 1e c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010536a:	0f 8e 1c 01 00 00    	jle    8010548c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105370:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105375:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105378:	74 66                	je     801053e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010537a:	83 ec 04             	sub    $0x4,%esp
8010537d:	6a 10                	push   $0x10
8010537f:	6a 00                	push   $0x0
80105381:	57                   	push   %edi
80105382:	e8 89 f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105387:	6a 10                	push   $0x10
80105389:	ff 75 c4             	push   -0x3c(%ebp)
8010538c:	57                   	push   %edi
8010538d:	ff 75 b4             	push   -0x4c(%ebp)
80105390:	e8 fb c7 ff ff       	call   80101b90 <writei>
80105395:	83 c4 20             	add    $0x20,%esp
80105398:	83 f8 10             	cmp    $0x10,%eax
8010539b:	0f 85 de 00 00 00    	jne    8010547f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a6:	0f 84 94 00 00 00    	je     80105440 <sys_unlink+0x180>
  iunlockput(dp);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	ff 75 b4             	push   -0x4c(%ebp)
801053b2:	e8 59 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801053b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053bc:	89 1c 24             	mov    %ebx,(%esp)
801053bf:	e8 0c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801053c4:	89 1c 24             	mov    %ebx,(%esp)
801053c7:	e8 44 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053cc:	e8 ff d9 ff ff       	call   80102dd0 <end_op>
  return 0;
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	31 c0                	xor    %eax,%eax
}
801053d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053e4:	76 94                	jbe    8010537a <sys_unlink+0xba>
801053e6:	be 20 00 00 00       	mov    $0x20,%esi
801053eb:	eb 0b                	jmp    801053f8 <sys_unlink+0x138>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c6 10             	add    $0x10,%esi
801053f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053f6:	73 82                	jae    8010537a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f8:	6a 10                	push   $0x10
801053fa:	56                   	push   %esi
801053fb:	57                   	push   %edi
801053fc:	53                   	push   %ebx
801053fd:	e8 8e c6 ff ff       	call   80101a90 <readi>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	83 f8 10             	cmp    $0x10,%eax
80105408:	75 68                	jne    80105472 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010540a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010540f:	74 df                	je     801053f0 <sys_unlink+0x130>
    iunlockput(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	53                   	push   %ebx
80105415:	e8 f6 c5 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	ff 75 b4             	push   -0x4c(%ebp)
80105426:	e8 e5 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010542b:	e8 a0 d9 ff ff       	call   80102dd0 <end_op>
  return -1;
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105438:	eb 9c                	jmp    801053d6 <sys_unlink+0x116>
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105443:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105446:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010544b:	50                   	push   %eax
8010544c:	e8 7f c2 ff ff       	call   801016d0 <iupdate>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	e9 53 ff ff ff       	jmp    801053ac <sys_unlink+0xec>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	e9 73 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
    end_op();
80105463:	e8 68 d9 ff ff       	call   80102dd0 <end_op>
    return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	e9 64 ff ff ff       	jmp    801053d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	68 a0 7c 10 80       	push   $0x80107ca0
8010547a:	e8 01 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	68 b2 7c 10 80       	push   $0x80107cb2
80105487:	e8 f4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 8e 7c 10 80       	push   $0x80107c8e
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_open>:

int
sys_open(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054a8:	53                   	push   %ebx
801054a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 dc f7 ff ff       	call   80104c90 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 8e 00 00 00    	js     8010554d <sys_open+0xad>
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c5:	50                   	push   %eax
801054c6:	6a 01                	push   $0x1
801054c8:	e8 03 f7 ff ff       	call   80104bd0 <argint>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 79                	js     8010554d <sys_open+0xad>
    return -1;

  begin_op();
801054d4:	e8 87 d8 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801054d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054dd:	75 79                	jne    80105558 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	ff 75 e0             	push   -0x20(%ebp)
801054e5:	e8 b6 cb ff ff       	call   801020a0 <namei>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	89 c6                	mov    %eax,%esi
801054ef:	85 c0                	test   %eax,%eax
801054f1:	0f 84 7e 00 00 00    	je     80105575 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054f7:	83 ec 0c             	sub    $0xc,%esp
801054fa:	50                   	push   %eax
801054fb:	e8 80 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105508:	0f 84 c2 00 00 00    	je     801055d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010550e:	e8 1d b9 ff ff       	call   80100e30 <filealloc>
80105513:	89 c7                	mov    %eax,%edi
80105515:	85 c0                	test   %eax,%eax
80105517:	74 23                	je     8010553c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105519:	e8 52 e4 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105520:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105524:	85 d2                	test   %edx,%edx
80105526:	74 60                	je     80105588 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105528:	83 c3 01             	add    $0x1,%ebx
8010552b:	83 fb 10             	cmp    $0x10,%ebx
8010552e:	75 f0                	jne    80105520 <sys_open+0x80>
    if(f)
      fileclose(f);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	57                   	push   %edi
80105534:	e8 b7 b9 ff ff       	call   80100ef0 <fileclose>
80105539:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 cb c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105545:	e8 86 d8 ff ff       	call   80102dd0 <end_op>
    return -1;
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105552:	eb 6d                	jmp    801055c1 <sys_open+0x121>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	31 c9                	xor    %ecx,%ecx
80105560:	ba 02 00 00 00       	mov    $0x2,%edx
80105565:	6a 00                	push   $0x0
80105567:	e8 14 f8 ff ff       	call   80104d80 <create>
    if(ip == 0){
8010556c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010556f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105571:	85 c0                	test   %eax,%eax
80105573:	75 99                	jne    8010550e <sys_open+0x6e>
      end_op();
80105575:	e8 56 d8 ff ff       	call   80102dd0 <end_op>
      return -1;
8010557a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010557f:	eb 40                	jmp    801055c1 <sys_open+0x121>
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010558b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010558f:	56                   	push   %esi
80105590:	e8 cb c2 ff ff       	call   80101860 <iunlock>
  end_op();
80105595:	e8 36 d8 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010559a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055b2:	f7 d0                	not    %eax
801055b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c4:	89 d8                	mov    %ebx,%eax
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5f                   	pop    %edi
801055c9:	5d                   	pop    %ebp
801055ca:	c3                   	ret    
801055cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055d3:	85 c9                	test   %ecx,%ecx
801055d5:	0f 84 33 ff ff ff    	je     8010550e <sys_open+0x6e>
801055db:	e9 5c ff ff ff       	jmp    8010553c <sys_open+0x9c>

801055e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055e6:	e8 75 d7 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 97 f6 ff ff       	call   80104c90 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 30                	js     80105630 <sys_mkdir+0x50>
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	31 c9                	xor    %ecx,%ecx
80105608:	ba 01 00 00 00       	mov    $0x1,%edx
8010560d:	6a 00                	push   $0x0
8010560f:	e8 6c f7 ff ff       	call   80104d80 <create>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	74 15                	je     80105630 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	50                   	push   %eax
8010561f:	e8 ec c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105624:	e8 a7 d7 ff ff       	call   80102dd0 <end_op>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	c9                   	leave  
8010562f:	c3                   	ret    
    end_op();
80105630:	e8 9b d7 ff ff       	call   80102dd0 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_mknod>:

int
sys_mknod(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105646:	e8 15 d7 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 37 f6 ff ff       	call   80104c90 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 60                	js     801056c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 62 f5 ff ff       	call   80104bd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 4b                	js     801056c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	6a 02                	push   $0x2
8010567e:	e8 4d f5 ff ff       	call   80104bd0 <argint>
     argint(1, &major) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 36                	js     801056c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010568a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010568e:	83 ec 0c             	sub    $0xc,%esp
80105691:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105695:	ba 03 00 00 00       	mov    $0x3,%edx
8010569a:	50                   	push   %eax
8010569b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010569e:	e8 dd f6 ff ff       	call   80104d80 <create>
     argint(2, &minor) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	74 16                	je     801056c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	50                   	push   %eax
801056ae:	e8 5d c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056b3:	e8 18 d7 ff ff       	call   80102dd0 <end_op>
  return 0;
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	31 c0                	xor    %eax,%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    
801056bf:	90                   	nop
    end_op();
801056c0:	e8 0b d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave  
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_chdir>:

int
sys_chdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056d8:	e8 93 e2 ff ff       	call   80103970 <myproc>
801056dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056df:	e8 7c d6 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ea:	50                   	push   %eax
801056eb:	6a 00                	push   $0x0
801056ed:	e8 9e f5 ff ff       	call   80104c90 <argstr>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 77                	js     80105770 <sys_chdir+0xa0>
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	ff 75 f4             	push   -0xc(%ebp)
801056ff:	e8 9c c9 ff ff       	call   801020a0 <namei>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	89 c3                	mov    %eax,%ebx
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 63                	je     80105770 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	50                   	push   %eax
80105711:	e8 6a c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010571e:	75 30                	jne    80105750 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 37 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105729:	58                   	pop    %eax
8010572a:	ff 76 68             	push   0x68(%esi)
8010572d:	e8 7e c1 ff ff       	call   801018b0 <iput>
  end_op();
80105732:	e8 99 d6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105737:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	31 c0                	xor    %eax,%eax
}
8010573f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105742:	5b                   	pop    %ebx
80105743:	5e                   	pop    %esi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	53                   	push   %ebx
80105754:	e8 b7 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105759:	e8 72 d6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	eb d7                	jmp    8010573f <sys_chdir+0x6f>
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
    end_op();
80105770:	e8 5b d6 ff ff       	call   80102dd0 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb c3                	jmp    8010573f <sys_chdir+0x6f>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exec>:

int
sys_exec(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105785:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010578b:	53                   	push   %ebx
8010578c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105792:	50                   	push   %eax
80105793:	6a 00                	push   $0x0
80105795:	e8 f6 f4 ff ff       	call   80104c90 <argstr>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 88 87 00 00 00    	js     8010582c <sys_exec+0xac>
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ae:	50                   	push   %eax
801057af:	6a 01                	push   $0x1
801057b1:	e8 1a f4 ff ff       	call   80104bd0 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 6f                	js     8010582c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057bd:	83 ec 04             	sub    $0x4,%esp
801057c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057c8:	68 80 00 00 00       	push   $0x80
801057cd:	6a 00                	push   $0x0
801057cf:	56                   	push   %esi
801057d0:	e8 3b f1 ff ff       	call   80104910 <memset>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057f0:	50                   	push   %eax
801057f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057f7:	01 f8                	add    %edi,%eax
801057f9:	50                   	push   %eax
801057fa:	e8 41 f3 ff ff       	call   80104b40 <fetchint>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 26                	js     8010582c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105806:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	74 30                	je     80105840 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 63 f3 ff ff       	call   80104b80 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 08                	js     8010582c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	75 b4                	jne    801057e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105840:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105847:	00 00 00 00 
  return exec(path, argv);
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	56                   	push   %esi
8010584f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105855:	e8 56 b2 ff ff       	call   80100ab0 <exec>
8010585a:	83 c4 10             	add    $0x10,%esp
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	5b                   	pop    %ebx
80105861:	5e                   	pop    %esi
80105862:	5f                   	pop    %edi
80105863:	5d                   	pop    %ebp
80105864:	c3                   	ret    
80105865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105875:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105878:	53                   	push   %ebx
80105879:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010587c:	6a 08                	push   $0x8
8010587e:	50                   	push   %eax
8010587f:	6a 00                	push   $0x0
80105881:	e8 9a f3 ff ff       	call   80104c20 <argptr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 4a                	js     801058d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010588d:	83 ec 08             	sub    $0x8,%esp
80105890:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105893:	50                   	push   %eax
80105894:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105897:	50                   	push   %eax
80105898:	e8 93 db ff ff       	call   80103430 <pipealloc>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 33                	js     801058d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058a9:	e8 c2 e0 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058b4:	85 f6                	test   %esi,%esi
801058b6:	74 28                	je     801058e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	83 fb 10             	cmp    $0x10,%ebx
801058be:	75 f0                	jne    801058b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	ff 75 e0             	push   -0x20(%ebp)
801058c6:	e8 25 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801058cb:	58                   	pop    %eax
801058cc:	ff 75 e4             	push   -0x1c(%ebp)
801058cf:	e8 1c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb 53                	jmp    80105931 <sys_pipe+0xc1>
801058de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058e0:	8d 73 08             	lea    0x8(%ebx),%esi
801058e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 81 e0 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 d2                	xor    %edx,%edx
801058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058fc:	85 c9                	test   %ecx,%ecx
801058fe:	74 20                	je     80105920 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c2 01             	add    $0x1,%edx
80105903:	83 fa 10             	cmp    $0x10,%edx
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105908:	e8 63 e0 ff ff       	call   80103970 <myproc>
8010590d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105914:	00 
80105915:	eb a9                	jmp    801058c0 <sys_pipe+0x50>
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105920:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105924:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105927:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105929:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010592c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010592f:	31 c0                	xor    %eax,%eax
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret    
80105939:	66 90                	xchg   %ax,%ax
8010593b:	66 90                	xchg   %ax,%ax
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105940:	e9 cb e1 ff ff       	jmp    80103b10 <fork>
80105945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_exit>:
}

int
sys_exit(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  exit();
80105956:	e8 35 e4 ff ff       	call   80103d90 <exit>
  return 0;  // not reached
}
8010595b:	31 c0                	xor    %eax,%eax
8010595d:	c9                   	leave  
8010595e:	c3                   	ret    
8010595f:	90                   	nop

80105960 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105960:	e9 5b e5 ff ff       	jmp    80103ec0 <wait>
80105965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_kill>:
}

int
sys_kill(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105976:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105979:	50                   	push   %eax
8010597a:	6a 00                	push   $0x0
8010597c:	e8 4f f2 ff ff       	call   80104bd0 <argint>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 18                	js     801059a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 f4             	push   -0xc(%ebp)
8010598e:	e8 cd e7 ff ff       	call   80104160 <kill>
80105993:	83 c4 10             	add    $0x10,%esp
}
80105996:	c9                   	leave  
80105997:	c3                   	ret    
80105998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
801059a0:	c9                   	leave  
    return -1;
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a6:	c3                   	ret    
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_getpid>:

int
sys_getpid(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059b6:	e8 b5 df ff ff       	call   80103970 <myproc>
801059bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059be:	c9                   	leave  
801059bf:	c3                   	ret    

801059c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ca:	50                   	push   %eax
801059cb:	6a 00                	push   $0x0
801059cd:	e8 fe f1 ff ff       	call   80104bd0 <argint>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	78 27                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059d9:	e8 92 df ff ff       	call   80103970 <myproc>
  if(growproc(n) < 0)
801059de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059e3:	ff 75 f4             	push   -0xc(%ebp)
801059e6:	e8 a5 e0 ff ff       	call   80103a90 <growproc>
801059eb:	83 c4 10             	add    $0x10,%esp
801059ee:	85 c0                	test   %eax,%eax
801059f0:	78 0e                	js     80105a00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059f2:	89 d8                	mov    %ebx,%eax
801059f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f7:	c9                   	leave  
801059f8:	c3                   	ret    
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a05:	eb eb                	jmp    801059f2 <sys_sbrk+0x32>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_sleep>:

int
sys_sleep(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 ae f1 ff ff       	call   80104bd0 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	0f 88 8a 00 00 00    	js     80105ab7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	68 80 3d 11 80       	push   $0x80113d80
80105a35:	e8 16 ee ff ff       	call   80104850 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a3d:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  while(ticks - ticks0 < n){
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 d2                	test   %edx,%edx
80105a48:	75 27                	jne    80105a71 <sys_sleep+0x61>
80105a4a:	eb 54                	jmp    80105aa0 <sys_sleep+0x90>
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	68 80 3d 11 80       	push   $0x80113d80
80105a58:	68 60 3d 11 80       	push   $0x80113d60
80105a5d:	e8 de e5 ff ff       	call   80104040 <sleep>
  while(ticks - ticks0 < n){
80105a62:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	29 d8                	sub    %ebx,%eax
80105a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a6f:	73 2f                	jae    80105aa0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a71:	e8 fa de ff ff       	call   80103970 <myproc>
80105a76:	8b 40 24             	mov    0x24(%eax),%eax
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	74 d3                	je     80105a50 <sys_sleep+0x40>
      release(&tickslock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 80 3d 11 80       	push   $0x80113d80
80105a85:	e8 66 ed ff ff       	call   801047f0 <release>
  }
  release(&tickslock);
  return 0;
}
80105a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	68 80 3d 11 80       	push   $0x80113d80
80105aa8:	e8 43 ed ff ff       	call   801047f0 <release>
  return 0;
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	31 c0                	xor    %eax,%eax
}
80105ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
    return -1;
80105ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abc:	eb f4                	jmp    80105ab2 <sys_sleep+0xa2>
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ac7:	68 80 3d 11 80       	push   $0x80113d80
80105acc:	e8 7f ed ff ff       	call   80104850 <acquire>
  xticks = ticks;
80105ad1:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  release(&tickslock);
80105ad7:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105ade:	e8 0d ed ff ff       	call   801047f0 <release>
  return xticks;
}
80105ae3:	89 d8                	mov    %ebx,%eax
80105ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae8:	c9                   	leave  
80105ae9:	c3                   	ret    
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105af0 <sys_clone>:

int sys_clone (void ) {
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 1c             	sub    $0x1c,%esp
  void* stack_ptr; 
  void* arg1; 
  void* arg2;   

  
  argptr(0, (void*)&fn_ptr, sizeof(void(*)(void* , void*)));
80105af6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105af9:	6a 04                	push   $0x4
80105afb:	50                   	push   %eax
80105afc:	6a 00                	push   $0x0
80105afe:	e8 1d f1 ff ff       	call   80104c20 <argptr>
  argptr(1, (void*)&arg1, sizeof(void*));
80105b03:	83 c4 0c             	add    $0xc,%esp
80105b06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b09:	6a 04                	push   $0x4
80105b0b:	50                   	push   %eax
80105b0c:	6a 01                	push   $0x1
80105b0e:	e8 0d f1 ff ff       	call   80104c20 <argptr>

  argptr(2, (void*)&arg2, sizeof(void*));
80105b13:	83 c4 0c             	add    $0xc,%esp
80105b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b19:	6a 04                	push   $0x4
80105b1b:	50                   	push   %eax
80105b1c:	6a 02                	push   $0x2
80105b1e:	e8 fd f0 ff ff       	call   80104c20 <argptr>

  argptr(3, (void*)&stack_ptr, sizeof(void*));
80105b23:	83 c4 0c             	add    $0xc,%esp
80105b26:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b29:	6a 04                	push   $0x4
80105b2b:	50                   	push   %eax
80105b2c:	6a 03                	push   $0x3
80105b2e:	e8 ed f0 ff ff       	call   80104c20 <argptr>

  // argptr(1, (void*)&arg1, sizeof(void*));
  // argptr(2, (void*)&arg2, sizeof(void*));


  return clone( fn_ptr , arg1, arg2, stack_ptr);
80105b33:	ff 75 ec             	push   -0x14(%ebp)
80105b36:	ff 75 f4             	push   -0xc(%ebp)
80105b39:	ff 75 f0             	push   -0x10(%ebp)
80105b3c:	ff 75 e8             	push   -0x18(%ebp)
80105b3f:	e8 5c e7 ff ff       	call   801042a0 <clone>
  
}
80105b44:	c9                   	leave  
80105b45:	c3                   	ret    
80105b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi

80105b50 <sys_join>:

int sys_join ( void ) {
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 1c             	sub    $0x1c,%esp
  void** stack_ptr;  

  argptr(0, (void*)&stack_ptr, sizeof(void**));
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	6a 04                	push   $0x4
80105b5b:	50                   	push   %eax
80105b5c:	6a 00                	push   $0x0
80105b5e:	e8 bd f0 ff ff       	call   80104c20 <argptr>

  return join(stack_ptr);
80105b63:	58                   	pop    %eax
80105b64:	ff 75 f4             	push   -0xc(%ebp)
80105b67:	e8 84 e8 ff ff       	call   801043f0 <join>

80105b6c:	c9                   	leave  
80105b6d:	c3                   	ret    

80105b6e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b6e:	1e                   	push   %ds
  pushl %es
80105b6f:	06                   	push   %es
  pushl %fs
80105b70:	0f a0                	push   %fs
  pushl %gs
80105b72:	0f a8                	push   %gs
  pushal
80105b74:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b75:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b79:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b7b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b7d:	54                   	push   %esp
  call trap
80105b7e:	e8 cd 00 00 00       	call   80105c50 <trap>
  addl $4, %esp
80105b83:	83 c4 04             	add    $0x4,%esp

80105b86 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b86:	61                   	popa   
  popl %gs
80105b87:	0f a9                	pop    %gs
  popl %fs
80105b89:	0f a1                	pop    %fs
  popl %es
80105b8b:	07                   	pop    %es
  popl %ds
80105b8c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b8d:	83 c4 08             	add    $0x8,%esp
  iret
80105b90:	cf                   	iret   
80105b91:	66 90                	xchg   %ax,%ax
80105b93:	66 90                	xchg   %ax,%ax
80105b95:	66 90                	xchg   %ax,%ax
80105b97:	66 90                	xchg   %ax,%ax
80105b99:	66 90                	xchg   %ax,%ax
80105b9b:	66 90                	xchg   %ax,%ax
80105b9d:	66 90                	xchg   %ax,%ax
80105b9f:	90                   	nop

80105ba0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ba0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ba1:	31 c0                	xor    %eax,%eax
{
80105ba3:	89 e5                	mov    %esp,%ebp
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bb0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bb7:	c7 04 c5 c2 3d 11 80 	movl   $0x8e000008,-0x7feec23e(,%eax,8)
80105bbe:	08 00 00 8e 
80105bc2:	66 89 14 c5 c0 3d 11 	mov    %dx,-0x7feec240(,%eax,8)
80105bc9:	80 
80105bca:	c1 ea 10             	shr    $0x10,%edx
80105bcd:	66 89 14 c5 c6 3d 11 	mov    %dx,-0x7feec23a(,%eax,8)
80105bd4:	80 
  for(i = 0; i < 256; i++)
80105bd5:	83 c0 01             	add    $0x1,%eax
80105bd8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bdd:	75 d1                	jne    80105bb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bdf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105be2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105be7:	c7 05 c2 3f 11 80 08 	movl   $0xef000008,0x80113fc2
80105bee:	00 00 ef 
  initlock(&tickslock, "time");
80105bf1:	68 c1 7c 10 80       	push   $0x80107cc1
80105bf6:	68 80 3d 11 80       	push   $0x80113d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bfb:	66 a3 c0 3f 11 80    	mov    %ax,0x80113fc0
80105c01:	c1 e8 10             	shr    $0x10,%eax
80105c04:	66 a3 c6 3f 11 80    	mov    %ax,0x80113fc6
  initlock(&tickslock, "time");
80105c0a:	e8 71 ea ff ff       	call   80104680 <initlock>
}
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <idtinit>:

void
idtinit(void)
{
80105c20:	55                   	push   %ebp
  pd[0] = size-1;
80105c21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c26:	89 e5                	mov    %esp,%ebp
80105c28:	83 ec 10             	sub    $0x10,%esp
80105c2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c2f:	b8 c0 3d 11 80       	mov    $0x80113dc0,%eax
80105c34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c38:	c1 e8 10             	shr    $0x10,%eax
80105c3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c45:	c9                   	leave  
80105c46:	c3                   	ret    
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
80105c56:	83 ec 1c             	sub    $0x1c,%esp
80105c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c5c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c5f:	83 f8 40             	cmp    $0x40,%eax
80105c62:	0f 84 68 01 00 00    	je     80105dd0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c68:	83 e8 20             	sub    $0x20,%eax
80105c6b:	83 f8 1f             	cmp    $0x1f,%eax
80105c6e:	0f 87 8c 00 00 00    	ja     80105d00 <trap+0xb0>
80105c74:	ff 24 85 68 7d 10 80 	jmp    *-0x7fef8298(,%eax,4)
80105c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c80:	e8 bb c5 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105c85:	e8 86 cc ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c8a:	e8 e1 dc ff ff       	call   80103970 <myproc>
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	74 1d                	je     80105cb0 <trap+0x60>
80105c93:	e8 d8 dc ff ff       	call   80103970 <myproc>
80105c98:	8b 50 24             	mov    0x24(%eax),%edx
80105c9b:	85 d2                	test   %edx,%edx
80105c9d:	74 11                	je     80105cb0 <trap+0x60>
80105c9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ca3:	83 e0 03             	and    $0x3,%eax
80105ca6:	66 83 f8 03          	cmp    $0x3,%ax
80105caa:	0f 84 e8 01 00 00    	je     80105e98 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cb0:	e8 bb dc ff ff       	call   80103970 <myproc>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	74 0f                	je     80105cc8 <trap+0x78>
80105cb9:	e8 b2 dc ff ff       	call   80103970 <myproc>
80105cbe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cc2:	0f 84 b8 00 00 00    	je     80105d80 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cc8:	e8 a3 dc ff ff       	call   80103970 <myproc>
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	74 1d                	je     80105cee <trap+0x9e>
80105cd1:	e8 9a dc ff ff       	call   80103970 <myproc>
80105cd6:	8b 40 24             	mov    0x24(%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	74 11                	je     80105cee <trap+0x9e>
80105cdd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ce1:	83 e0 03             	and    $0x3,%eax
80105ce4:	66 83 f8 03          	cmp    $0x3,%ax
80105ce8:	0f 84 0f 01 00 00    	je     80105dfd <trap+0x1ad>
    exit();
}
80105cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf1:	5b                   	pop    %ebx
80105cf2:	5e                   	pop    %esi
80105cf3:	5f                   	pop    %edi
80105cf4:	5d                   	pop    %ebp
80105cf5:	c3                   	ret    
80105cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d00:	e8 6b dc ff ff       	call   80103970 <myproc>
80105d05:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d08:	85 c0                	test   %eax,%eax
80105d0a:	0f 84 a2 01 00 00    	je     80105eb2 <trap+0x262>
80105d10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d14:	0f 84 98 01 00 00    	je     80105eb2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d1a:	0f 20 d1             	mov    %cr2,%ecx
80105d1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d20:	e8 2b dc ff ff       	call   80103950 <cpuid>
80105d25:	8b 73 30             	mov    0x30(%ebx),%esi
80105d28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d2b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d31:	e8 3a dc ff ff       	call   80103970 <myproc>
80105d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d39:	e8 32 dc ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d44:	51                   	push   %ecx
80105d45:	57                   	push   %edi
80105d46:	52                   	push   %edx
80105d47:	ff 75 e4             	push   -0x1c(%ebp)
80105d4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d4e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d51:	56                   	push   %esi
80105d52:	ff 70 10             	push   0x10(%eax)
80105d55:	68 24 7d 10 80       	push   $0x80107d24
80105d5a:	e8 41 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d5f:	83 c4 20             	add    $0x20,%esp
80105d62:	e8 09 dc ff ff       	call   80103970 <myproc>
80105d67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d6e:	e8 fd db ff ff       	call   80103970 <myproc>
80105d73:	85 c0                	test   %eax,%eax
80105d75:	0f 85 18 ff ff ff    	jne    80105c93 <trap+0x43>
80105d7b:	e9 30 ff ff ff       	jmp    80105cb0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105d80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d84:	0f 85 3e ff ff ff    	jne    80105cc8 <trap+0x78>
    yield();
80105d8a:	e8 61 e2 ff ff       	call   80103ff0 <yield>
80105d8f:	e9 34 ff ff ff       	jmp    80105cc8 <trap+0x78>
80105d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d98:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d9f:	e8 ac db ff ff       	call   80103950 <cpuid>
80105da4:	57                   	push   %edi
80105da5:	56                   	push   %esi
80105da6:	50                   	push   %eax
80105da7:	68 cc 7c 10 80       	push   $0x80107ccc
80105dac:	e8 ef a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105db1:	e8 5a cb ff ff       	call   80102910 <lapiceoi>
    break;
80105db6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db9:	e8 b2 db ff ff       	call   80103970 <myproc>
80105dbe:	85 c0                	test   %eax,%eax
80105dc0:	0f 85 cd fe ff ff    	jne    80105c93 <trap+0x43>
80105dc6:	e9 e5 fe ff ff       	jmp    80105cb0 <trap+0x60>
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop
    if(myproc()->killed)
80105dd0:	e8 9b db ff ff       	call   80103970 <myproc>
80105dd5:	8b 70 24             	mov    0x24(%eax),%esi
80105dd8:	85 f6                	test   %esi,%esi
80105dda:	0f 85 c8 00 00 00    	jne    80105ea8 <trap+0x258>
    myproc()->tf = tf;
80105de0:	e8 8b db ff ff       	call   80103970 <myproc>
80105de5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105de8:	e8 23 ef ff ff       	call   80104d10 <syscall>
    if(myproc()->killed)
80105ded:	e8 7e db ff ff       	call   80103970 <myproc>
80105df2:	8b 48 24             	mov    0x24(%eax),%ecx
80105df5:	85 c9                	test   %ecx,%ecx
80105df7:	0f 84 f1 fe ff ff    	je     80105cee <trap+0x9e>
}
80105dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e00:	5b                   	pop    %ebx
80105e01:	5e                   	pop    %esi
80105e02:	5f                   	pop    %edi
80105e03:	5d                   	pop    %ebp
      exit();
80105e04:	e9 87 df ff ff       	jmp    80103d90 <exit>
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e10:	e8 3b 02 00 00       	call   80106050 <uartintr>
    lapiceoi();
80105e15:	e8 f6 ca ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1a:	e8 51 db ff ff       	call   80103970 <myproc>
80105e1f:	85 c0                	test   %eax,%eax
80105e21:	0f 85 6c fe ff ff    	jne    80105c93 <trap+0x43>
80105e27:	e9 84 fe ff ff       	jmp    80105cb0 <trap+0x60>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e30:	e8 9b c9 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105e35:	e8 d6 ca ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3a:	e8 31 db ff ff       	call   80103970 <myproc>
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	0f 85 4c fe ff ff    	jne    80105c93 <trap+0x43>
80105e47:	e9 64 fe ff ff       	jmp    80105cb0 <trap+0x60>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105e50:	e8 fb da ff ff       	call   80103950 <cpuid>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	0f 85 28 fe ff ff    	jne    80105c85 <trap+0x35>
      acquire(&tickslock);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 80 3d 11 80       	push   $0x80113d80
80105e65:	e8 e6 e9 ff ff       	call   80104850 <acquire>
      wakeup(&ticks);
80105e6a:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
      ticks++;
80105e71:	83 05 60 3d 11 80 01 	addl   $0x1,0x80113d60
      wakeup(&ticks);
80105e78:	e8 83 e2 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105e7d:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105e84:	e8 67 e9 ff ff       	call   801047f0 <release>
80105e89:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e8c:	e9 f4 fd ff ff       	jmp    80105c85 <trap+0x35>
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e98:	e8 f3 de ff ff       	call   80103d90 <exit>
80105e9d:	e9 0e fe ff ff       	jmp    80105cb0 <trap+0x60>
80105ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ea8:	e8 e3 de ff ff       	call   80103d90 <exit>
80105ead:	e9 2e ff ff ff       	jmp    80105de0 <trap+0x190>
80105eb2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105eb5:	e8 96 da ff ff       	call   80103950 <cpuid>
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	56                   	push   %esi
80105ebe:	57                   	push   %edi
80105ebf:	50                   	push   %eax
80105ec0:	ff 73 30             	push   0x30(%ebx)
80105ec3:	68 f0 7c 10 80       	push   $0x80107cf0
80105ec8:	e8 d3 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105ecd:	83 c4 14             	add    $0x14,%esp
80105ed0:	68 c6 7c 10 80       	push   $0x80107cc6
80105ed5:	e8 a6 a4 ff ff       	call   80100380 <panic>
80105eda:	66 90                	xchg   %ax,%ax
80105edc:	66 90                	xchg   %ax,%ax
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ee0:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 17                	je     80105f00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ee9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eef:	a8 01                	test   $0x1,%al
80105ef1:	74 0d                	je     80105f00 <uartgetc+0x20>
80105ef3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ef8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ef9:	0f b6 c0             	movzbl %al,%eax
80105efc:	c3                   	ret    
80105efd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f05:	c3                   	ret    
80105f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi

80105f10 <uartinit>:
{
80105f10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f11:	31 c9                	xor    %ecx,%ecx
80105f13:	89 c8                	mov    %ecx,%eax
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	57                   	push   %edi
80105f18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f1d:	56                   	push   %esi
80105f1e:	89 fa                	mov    %edi,%edx
80105f20:	53                   	push   %ebx
80105f21:	83 ec 1c             	sub    $0x1c,%esp
80105f24:	ee                   	out    %al,(%dx)
80105f25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f2f:	89 f2                	mov    %esi,%edx
80105f31:	ee                   	out    %al,(%dx)
80105f32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3c:	ee                   	out    %al,(%dx)
80105f3d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f42:	89 c8                	mov    %ecx,%eax
80105f44:	89 da                	mov    %ebx,%edx
80105f46:	ee                   	out    %al,(%dx)
80105f47:	b8 03 00 00 00       	mov    $0x3,%eax
80105f4c:	89 f2                	mov    %esi,%edx
80105f4e:	ee                   	out    %al,(%dx)
80105f4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f54:	89 c8                	mov    %ecx,%eax
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 01 00 00 00       	mov    $0x1,%eax
80105f5c:	89 da                	mov    %ebx,%edx
80105f5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f65:	3c ff                	cmp    $0xff,%al
80105f67:	74 78                	je     80105fe1 <uartinit+0xd1>
  uart = 1;
80105f69:	c7 05 c0 45 11 80 01 	movl   $0x1,0x801145c0
80105f70:	00 00 00 
80105f73:	89 fa                	mov    %edi,%edx
80105f75:	ec                   	in     (%dx),%al
80105f76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f7f:	bf e8 7d 10 80       	mov    $0x80107de8,%edi
80105f84:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f89:	6a 00                	push   $0x0
80105f8b:	6a 04                	push   $0x4
80105f8d:	e8 ee c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f92:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105fa0:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105fa5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105faa:	85 c0                	test   %eax,%eax
80105fac:	75 14                	jne    80105fc2 <uartinit+0xb2>
80105fae:	eb 23                	jmp    80105fd3 <uartinit+0xc3>
    microdelay(10);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	6a 0a                	push   $0xa
80105fb5:	e8 76 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	83 eb 01             	sub    $0x1,%ebx
80105fc0:	74 07                	je     80105fc9 <uartinit+0xb9>
80105fc2:	89 f2                	mov    %esi,%edx
80105fc4:	ec                   	in     (%dx),%al
80105fc5:	a8 20                	test   $0x20,%al
80105fc7:	74 e7                	je     80105fb0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fc9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105fcd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fd2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fd3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fd7:	83 c7 01             	add    $0x1,%edi
80105fda:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fdd:	84 c0                	test   %al,%al
80105fdf:	75 bf                	jne    80105fa0 <uartinit+0x90>
}
80105fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe4:	5b                   	pop    %ebx
80105fe5:	5e                   	pop    %esi
80105fe6:	5f                   	pop    %edi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartputc>:
  if(!uart)
80105ff0:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	74 47                	je     80106040 <uartputc+0x50>
{
80105ff9:	55                   	push   %ebp
80105ffa:	89 e5                	mov    %esp,%ebp
80105ffc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ffd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106002:	53                   	push   %ebx
80106003:	bb 80 00 00 00       	mov    $0x80,%ebx
80106008:	eb 18                	jmp    80106022 <uartputc+0x32>
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 16 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartputc+0x39>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	8b 45 08             	mov    0x8(%ebp),%eax
8010602c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106031:	ee                   	out    %al,(%dx)
}
80106032:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106035:	5b                   	pop    %ebx
80106036:	5e                   	pop    %esi
80106037:	5d                   	pop    %ebp
80106038:	c3                   	ret    
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106040:	c3                   	ret    
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop

80106050 <uartintr>:

void
uartintr(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106056:	68 e0 5e 10 80       	push   $0x80105ee0
8010605b:	e8 20 a8 ff ff       	call   80100880 <consoleintr>
}
80106060:	83 c4 10             	add    $0x10,%esp
80106063:	c9                   	leave  
80106064:	c3                   	ret    

80106065 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $0
80106067:	6a 00                	push   $0x0
  jmp alltraps
80106069:	e9 00 fb ff ff       	jmp    80105b6e <alltraps>

8010606e <vector1>:
.globl vector1
vector1:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $1
80106070:	6a 01                	push   $0x1
  jmp alltraps
80106072:	e9 f7 fa ff ff       	jmp    80105b6e <alltraps>

80106077 <vector2>:
.globl vector2
vector2:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $2
80106079:	6a 02                	push   $0x2
  jmp alltraps
8010607b:	e9 ee fa ff ff       	jmp    80105b6e <alltraps>

80106080 <vector3>:
.globl vector3
vector3:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $3
80106082:	6a 03                	push   $0x3
  jmp alltraps
80106084:	e9 e5 fa ff ff       	jmp    80105b6e <alltraps>

80106089 <vector4>:
.globl vector4
vector4:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $4
8010608b:	6a 04                	push   $0x4
  jmp alltraps
8010608d:	e9 dc fa ff ff       	jmp    80105b6e <alltraps>

80106092 <vector5>:
.globl vector5
vector5:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $5
80106094:	6a 05                	push   $0x5
  jmp alltraps
80106096:	e9 d3 fa ff ff       	jmp    80105b6e <alltraps>

8010609b <vector6>:
.globl vector6
vector6:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $6
8010609d:	6a 06                	push   $0x6
  jmp alltraps
8010609f:	e9 ca fa ff ff       	jmp    80105b6e <alltraps>

801060a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $7
801060a6:	6a 07                	push   $0x7
  jmp alltraps
801060a8:	e9 c1 fa ff ff       	jmp    80105b6e <alltraps>

801060ad <vector8>:
.globl vector8
vector8:
  pushl $8
801060ad:	6a 08                	push   $0x8
  jmp alltraps
801060af:	e9 ba fa ff ff       	jmp    80105b6e <alltraps>

801060b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $9
801060b6:	6a 09                	push   $0x9
  jmp alltraps
801060b8:	e9 b1 fa ff ff       	jmp    80105b6e <alltraps>

801060bd <vector10>:
.globl vector10
vector10:
  pushl $10
801060bd:	6a 0a                	push   $0xa
  jmp alltraps
801060bf:	e9 aa fa ff ff       	jmp    80105b6e <alltraps>

801060c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060c4:	6a 0b                	push   $0xb
  jmp alltraps
801060c6:	e9 a3 fa ff ff       	jmp    80105b6e <alltraps>

801060cb <vector12>:
.globl vector12
vector12:
  pushl $12
801060cb:	6a 0c                	push   $0xc
  jmp alltraps
801060cd:	e9 9c fa ff ff       	jmp    80105b6e <alltraps>

801060d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060d2:	6a 0d                	push   $0xd
  jmp alltraps
801060d4:	e9 95 fa ff ff       	jmp    80105b6e <alltraps>

801060d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060d9:	6a 0e                	push   $0xe
  jmp alltraps
801060db:	e9 8e fa ff ff       	jmp    80105b6e <alltraps>

801060e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $15
801060e2:	6a 0f                	push   $0xf
  jmp alltraps
801060e4:	e9 85 fa ff ff       	jmp    80105b6e <alltraps>

801060e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $16
801060eb:	6a 10                	push   $0x10
  jmp alltraps
801060ed:	e9 7c fa ff ff       	jmp    80105b6e <alltraps>

801060f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060f2:	6a 11                	push   $0x11
  jmp alltraps
801060f4:	e9 75 fa ff ff       	jmp    80105b6e <alltraps>

801060f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $18
801060fb:	6a 12                	push   $0x12
  jmp alltraps
801060fd:	e9 6c fa ff ff       	jmp    80105b6e <alltraps>

80106102 <vector19>:
.globl vector19
vector19:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $19
80106104:	6a 13                	push   $0x13
  jmp alltraps
80106106:	e9 63 fa ff ff       	jmp    80105b6e <alltraps>

8010610b <vector20>:
.globl vector20
vector20:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $20
8010610d:	6a 14                	push   $0x14
  jmp alltraps
8010610f:	e9 5a fa ff ff       	jmp    80105b6e <alltraps>

80106114 <vector21>:
.globl vector21
vector21:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $21
80106116:	6a 15                	push   $0x15
  jmp alltraps
80106118:	e9 51 fa ff ff       	jmp    80105b6e <alltraps>

8010611d <vector22>:
.globl vector22
vector22:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $22
8010611f:	6a 16                	push   $0x16
  jmp alltraps
80106121:	e9 48 fa ff ff       	jmp    80105b6e <alltraps>

80106126 <vector23>:
.globl vector23
vector23:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $23
80106128:	6a 17                	push   $0x17
  jmp alltraps
8010612a:	e9 3f fa ff ff       	jmp    80105b6e <alltraps>

8010612f <vector24>:
.globl vector24
vector24:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $24
80106131:	6a 18                	push   $0x18
  jmp alltraps
80106133:	e9 36 fa ff ff       	jmp    80105b6e <alltraps>

80106138 <vector25>:
.globl vector25
vector25:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $25
8010613a:	6a 19                	push   $0x19
  jmp alltraps
8010613c:	e9 2d fa ff ff       	jmp    80105b6e <alltraps>

80106141 <vector26>:
.globl vector26
vector26:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $26
80106143:	6a 1a                	push   $0x1a
  jmp alltraps
80106145:	e9 24 fa ff ff       	jmp    80105b6e <alltraps>

8010614a <vector27>:
.globl vector27
vector27:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $27
8010614c:	6a 1b                	push   $0x1b
  jmp alltraps
8010614e:	e9 1b fa ff ff       	jmp    80105b6e <alltraps>

80106153 <vector28>:
.globl vector28
vector28:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $28
80106155:	6a 1c                	push   $0x1c
  jmp alltraps
80106157:	e9 12 fa ff ff       	jmp    80105b6e <alltraps>

8010615c <vector29>:
.globl vector29
vector29:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $29
8010615e:	6a 1d                	push   $0x1d
  jmp alltraps
80106160:	e9 09 fa ff ff       	jmp    80105b6e <alltraps>

80106165 <vector30>:
.globl vector30
vector30:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $30
80106167:	6a 1e                	push   $0x1e
  jmp alltraps
80106169:	e9 00 fa ff ff       	jmp    80105b6e <alltraps>

8010616e <vector31>:
.globl vector31
vector31:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $31
80106170:	6a 1f                	push   $0x1f
  jmp alltraps
80106172:	e9 f7 f9 ff ff       	jmp    80105b6e <alltraps>

80106177 <vector32>:
.globl vector32
vector32:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $32
80106179:	6a 20                	push   $0x20
  jmp alltraps
8010617b:	e9 ee f9 ff ff       	jmp    80105b6e <alltraps>

80106180 <vector33>:
.globl vector33
vector33:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $33
80106182:	6a 21                	push   $0x21
  jmp alltraps
80106184:	e9 e5 f9 ff ff       	jmp    80105b6e <alltraps>

80106189 <vector34>:
.globl vector34
vector34:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $34
8010618b:	6a 22                	push   $0x22
  jmp alltraps
8010618d:	e9 dc f9 ff ff       	jmp    80105b6e <alltraps>

80106192 <vector35>:
.globl vector35
vector35:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $35
80106194:	6a 23                	push   $0x23
  jmp alltraps
80106196:	e9 d3 f9 ff ff       	jmp    80105b6e <alltraps>

8010619b <vector36>:
.globl vector36
vector36:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $36
8010619d:	6a 24                	push   $0x24
  jmp alltraps
8010619f:	e9 ca f9 ff ff       	jmp    80105b6e <alltraps>

801061a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $37
801061a6:	6a 25                	push   $0x25
  jmp alltraps
801061a8:	e9 c1 f9 ff ff       	jmp    80105b6e <alltraps>

801061ad <vector38>:
.globl vector38
vector38:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $38
801061af:	6a 26                	push   $0x26
  jmp alltraps
801061b1:	e9 b8 f9 ff ff       	jmp    80105b6e <alltraps>

801061b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $39
801061b8:	6a 27                	push   $0x27
  jmp alltraps
801061ba:	e9 af f9 ff ff       	jmp    80105b6e <alltraps>

801061bf <vector40>:
.globl vector40
vector40:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $40
801061c1:	6a 28                	push   $0x28
  jmp alltraps
801061c3:	e9 a6 f9 ff ff       	jmp    80105b6e <alltraps>

801061c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $41
801061ca:	6a 29                	push   $0x29
  jmp alltraps
801061cc:	e9 9d f9 ff ff       	jmp    80105b6e <alltraps>

801061d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $42
801061d3:	6a 2a                	push   $0x2a
  jmp alltraps
801061d5:	e9 94 f9 ff ff       	jmp    80105b6e <alltraps>

801061da <vector43>:
.globl vector43
vector43:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $43
801061dc:	6a 2b                	push   $0x2b
  jmp alltraps
801061de:	e9 8b f9 ff ff       	jmp    80105b6e <alltraps>

801061e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $44
801061e5:	6a 2c                	push   $0x2c
  jmp alltraps
801061e7:	e9 82 f9 ff ff       	jmp    80105b6e <alltraps>

801061ec <vector45>:
.globl vector45
vector45:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $45
801061ee:	6a 2d                	push   $0x2d
  jmp alltraps
801061f0:	e9 79 f9 ff ff       	jmp    80105b6e <alltraps>

801061f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $46
801061f7:	6a 2e                	push   $0x2e
  jmp alltraps
801061f9:	e9 70 f9 ff ff       	jmp    80105b6e <alltraps>

801061fe <vector47>:
.globl vector47
vector47:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $47
80106200:	6a 2f                	push   $0x2f
  jmp alltraps
80106202:	e9 67 f9 ff ff       	jmp    80105b6e <alltraps>

80106207 <vector48>:
.globl vector48
vector48:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $48
80106209:	6a 30                	push   $0x30
  jmp alltraps
8010620b:	e9 5e f9 ff ff       	jmp    80105b6e <alltraps>

80106210 <vector49>:
.globl vector49
vector49:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $49
80106212:	6a 31                	push   $0x31
  jmp alltraps
80106214:	e9 55 f9 ff ff       	jmp    80105b6e <alltraps>

80106219 <vector50>:
.globl vector50
vector50:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $50
8010621b:	6a 32                	push   $0x32
  jmp alltraps
8010621d:	e9 4c f9 ff ff       	jmp    80105b6e <alltraps>

80106222 <vector51>:
.globl vector51
vector51:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $51
80106224:	6a 33                	push   $0x33
  jmp alltraps
80106226:	e9 43 f9 ff ff       	jmp    80105b6e <alltraps>

8010622b <vector52>:
.globl vector52
vector52:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $52
8010622d:	6a 34                	push   $0x34
  jmp alltraps
8010622f:	e9 3a f9 ff ff       	jmp    80105b6e <alltraps>

80106234 <vector53>:
.globl vector53
vector53:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $53
80106236:	6a 35                	push   $0x35
  jmp alltraps
80106238:	e9 31 f9 ff ff       	jmp    80105b6e <alltraps>

8010623d <vector54>:
.globl vector54
vector54:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $54
8010623f:	6a 36                	push   $0x36
  jmp alltraps
80106241:	e9 28 f9 ff ff       	jmp    80105b6e <alltraps>

80106246 <vector55>:
.globl vector55
vector55:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $55
80106248:	6a 37                	push   $0x37
  jmp alltraps
8010624a:	e9 1f f9 ff ff       	jmp    80105b6e <alltraps>

8010624f <vector56>:
.globl vector56
vector56:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $56
80106251:	6a 38                	push   $0x38
  jmp alltraps
80106253:	e9 16 f9 ff ff       	jmp    80105b6e <alltraps>

80106258 <vector57>:
.globl vector57
vector57:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $57
8010625a:	6a 39                	push   $0x39
  jmp alltraps
8010625c:	e9 0d f9 ff ff       	jmp    80105b6e <alltraps>

80106261 <vector58>:
.globl vector58
vector58:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $58
80106263:	6a 3a                	push   $0x3a
  jmp alltraps
80106265:	e9 04 f9 ff ff       	jmp    80105b6e <alltraps>

8010626a <vector59>:
.globl vector59
vector59:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $59
8010626c:	6a 3b                	push   $0x3b
  jmp alltraps
8010626e:	e9 fb f8 ff ff       	jmp    80105b6e <alltraps>

80106273 <vector60>:
.globl vector60
vector60:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $60
80106275:	6a 3c                	push   $0x3c
  jmp alltraps
80106277:	e9 f2 f8 ff ff       	jmp    80105b6e <alltraps>

8010627c <vector61>:
.globl vector61
vector61:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $61
8010627e:	6a 3d                	push   $0x3d
  jmp alltraps
80106280:	e9 e9 f8 ff ff       	jmp    80105b6e <alltraps>

80106285 <vector62>:
.globl vector62
vector62:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $62
80106287:	6a 3e                	push   $0x3e
  jmp alltraps
80106289:	e9 e0 f8 ff ff       	jmp    80105b6e <alltraps>

8010628e <vector63>:
.globl vector63
vector63:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $63
80106290:	6a 3f                	push   $0x3f
  jmp alltraps
80106292:	e9 d7 f8 ff ff       	jmp    80105b6e <alltraps>

80106297 <vector64>:
.globl vector64
vector64:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $64
80106299:	6a 40                	push   $0x40
  jmp alltraps
8010629b:	e9 ce f8 ff ff       	jmp    80105b6e <alltraps>

801062a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $65
801062a2:	6a 41                	push   $0x41
  jmp alltraps
801062a4:	e9 c5 f8 ff ff       	jmp    80105b6e <alltraps>

801062a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $66
801062ab:	6a 42                	push   $0x42
  jmp alltraps
801062ad:	e9 bc f8 ff ff       	jmp    80105b6e <alltraps>

801062b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $67
801062b4:	6a 43                	push   $0x43
  jmp alltraps
801062b6:	e9 b3 f8 ff ff       	jmp    80105b6e <alltraps>

801062bb <vector68>:
.globl vector68
vector68:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $68
801062bd:	6a 44                	push   $0x44
  jmp alltraps
801062bf:	e9 aa f8 ff ff       	jmp    80105b6e <alltraps>

801062c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $69
801062c6:	6a 45                	push   $0x45
  jmp alltraps
801062c8:	e9 a1 f8 ff ff       	jmp    80105b6e <alltraps>

801062cd <vector70>:
.globl vector70
vector70:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $70
801062cf:	6a 46                	push   $0x46
  jmp alltraps
801062d1:	e9 98 f8 ff ff       	jmp    80105b6e <alltraps>

801062d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $71
801062d8:	6a 47                	push   $0x47
  jmp alltraps
801062da:	e9 8f f8 ff ff       	jmp    80105b6e <alltraps>

801062df <vector72>:
.globl vector72
vector72:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $72
801062e1:	6a 48                	push   $0x48
  jmp alltraps
801062e3:	e9 86 f8 ff ff       	jmp    80105b6e <alltraps>

801062e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $73
801062ea:	6a 49                	push   $0x49
  jmp alltraps
801062ec:	e9 7d f8 ff ff       	jmp    80105b6e <alltraps>

801062f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $74
801062f3:	6a 4a                	push   $0x4a
  jmp alltraps
801062f5:	e9 74 f8 ff ff       	jmp    80105b6e <alltraps>

801062fa <vector75>:
.globl vector75
vector75:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $75
801062fc:	6a 4b                	push   $0x4b
  jmp alltraps
801062fe:	e9 6b f8 ff ff       	jmp    80105b6e <alltraps>

80106303 <vector76>:
.globl vector76
vector76:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $76
80106305:	6a 4c                	push   $0x4c
  jmp alltraps
80106307:	e9 62 f8 ff ff       	jmp    80105b6e <alltraps>

8010630c <vector77>:
.globl vector77
vector77:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $77
8010630e:	6a 4d                	push   $0x4d
  jmp alltraps
80106310:	e9 59 f8 ff ff       	jmp    80105b6e <alltraps>

80106315 <vector78>:
.globl vector78
vector78:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $78
80106317:	6a 4e                	push   $0x4e
  jmp alltraps
80106319:	e9 50 f8 ff ff       	jmp    80105b6e <alltraps>

8010631e <vector79>:
.globl vector79
vector79:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $79
80106320:	6a 4f                	push   $0x4f
  jmp alltraps
80106322:	e9 47 f8 ff ff       	jmp    80105b6e <alltraps>

80106327 <vector80>:
.globl vector80
vector80:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $80
80106329:	6a 50                	push   $0x50
  jmp alltraps
8010632b:	e9 3e f8 ff ff       	jmp    80105b6e <alltraps>

80106330 <vector81>:
.globl vector81
vector81:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $81
80106332:	6a 51                	push   $0x51
  jmp alltraps
80106334:	e9 35 f8 ff ff       	jmp    80105b6e <alltraps>

80106339 <vector82>:
.globl vector82
vector82:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $82
8010633b:	6a 52                	push   $0x52
  jmp alltraps
8010633d:	e9 2c f8 ff ff       	jmp    80105b6e <alltraps>

80106342 <vector83>:
.globl vector83
vector83:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $83
80106344:	6a 53                	push   $0x53
  jmp alltraps
80106346:	e9 23 f8 ff ff       	jmp    80105b6e <alltraps>

8010634b <vector84>:
.globl vector84
vector84:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $84
8010634d:	6a 54                	push   $0x54
  jmp alltraps
8010634f:	e9 1a f8 ff ff       	jmp    80105b6e <alltraps>

80106354 <vector85>:
.globl vector85
vector85:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $85
80106356:	6a 55                	push   $0x55
  jmp alltraps
80106358:	e9 11 f8 ff ff       	jmp    80105b6e <alltraps>

8010635d <vector86>:
.globl vector86
vector86:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $86
8010635f:	6a 56                	push   $0x56
  jmp alltraps
80106361:	e9 08 f8 ff ff       	jmp    80105b6e <alltraps>

80106366 <vector87>:
.globl vector87
vector87:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $87
80106368:	6a 57                	push   $0x57
  jmp alltraps
8010636a:	e9 ff f7 ff ff       	jmp    80105b6e <alltraps>

8010636f <vector88>:
.globl vector88
vector88:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $88
80106371:	6a 58                	push   $0x58
  jmp alltraps
80106373:	e9 f6 f7 ff ff       	jmp    80105b6e <alltraps>

80106378 <vector89>:
.globl vector89
vector89:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $89
8010637a:	6a 59                	push   $0x59
  jmp alltraps
8010637c:	e9 ed f7 ff ff       	jmp    80105b6e <alltraps>

80106381 <vector90>:
.globl vector90
vector90:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $90
80106383:	6a 5a                	push   $0x5a
  jmp alltraps
80106385:	e9 e4 f7 ff ff       	jmp    80105b6e <alltraps>

8010638a <vector91>:
.globl vector91
vector91:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $91
8010638c:	6a 5b                	push   $0x5b
  jmp alltraps
8010638e:	e9 db f7 ff ff       	jmp    80105b6e <alltraps>

80106393 <vector92>:
.globl vector92
vector92:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $92
80106395:	6a 5c                	push   $0x5c
  jmp alltraps
80106397:	e9 d2 f7 ff ff       	jmp    80105b6e <alltraps>

8010639c <vector93>:
.globl vector93
vector93:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $93
8010639e:	6a 5d                	push   $0x5d
  jmp alltraps
801063a0:	e9 c9 f7 ff ff       	jmp    80105b6e <alltraps>

801063a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $94
801063a7:	6a 5e                	push   $0x5e
  jmp alltraps
801063a9:	e9 c0 f7 ff ff       	jmp    80105b6e <alltraps>

801063ae <vector95>:
.globl vector95
vector95:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $95
801063b0:	6a 5f                	push   $0x5f
  jmp alltraps
801063b2:	e9 b7 f7 ff ff       	jmp    80105b6e <alltraps>

801063b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $96
801063b9:	6a 60                	push   $0x60
  jmp alltraps
801063bb:	e9 ae f7 ff ff       	jmp    80105b6e <alltraps>

801063c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $97
801063c2:	6a 61                	push   $0x61
  jmp alltraps
801063c4:	e9 a5 f7 ff ff       	jmp    80105b6e <alltraps>

801063c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $98
801063cb:	6a 62                	push   $0x62
  jmp alltraps
801063cd:	e9 9c f7 ff ff       	jmp    80105b6e <alltraps>

801063d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $99
801063d4:	6a 63                	push   $0x63
  jmp alltraps
801063d6:	e9 93 f7 ff ff       	jmp    80105b6e <alltraps>

801063db <vector100>:
.globl vector100
vector100:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $100
801063dd:	6a 64                	push   $0x64
  jmp alltraps
801063df:	e9 8a f7 ff ff       	jmp    80105b6e <alltraps>

801063e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $101
801063e6:	6a 65                	push   $0x65
  jmp alltraps
801063e8:	e9 81 f7 ff ff       	jmp    80105b6e <alltraps>

801063ed <vector102>:
.globl vector102
vector102:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $102
801063ef:	6a 66                	push   $0x66
  jmp alltraps
801063f1:	e9 78 f7 ff ff       	jmp    80105b6e <alltraps>

801063f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $103
801063f8:	6a 67                	push   $0x67
  jmp alltraps
801063fa:	e9 6f f7 ff ff       	jmp    80105b6e <alltraps>

801063ff <vector104>:
.globl vector104
vector104:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $104
80106401:	6a 68                	push   $0x68
  jmp alltraps
80106403:	e9 66 f7 ff ff       	jmp    80105b6e <alltraps>

80106408 <vector105>:
.globl vector105
vector105:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $105
8010640a:	6a 69                	push   $0x69
  jmp alltraps
8010640c:	e9 5d f7 ff ff       	jmp    80105b6e <alltraps>

80106411 <vector106>:
.globl vector106
vector106:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $106
80106413:	6a 6a                	push   $0x6a
  jmp alltraps
80106415:	e9 54 f7 ff ff       	jmp    80105b6e <alltraps>

8010641a <vector107>:
.globl vector107
vector107:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $107
8010641c:	6a 6b                	push   $0x6b
  jmp alltraps
8010641e:	e9 4b f7 ff ff       	jmp    80105b6e <alltraps>

80106423 <vector108>:
.globl vector108
vector108:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $108
80106425:	6a 6c                	push   $0x6c
  jmp alltraps
80106427:	e9 42 f7 ff ff       	jmp    80105b6e <alltraps>

8010642c <vector109>:
.globl vector109
vector109:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $109
8010642e:	6a 6d                	push   $0x6d
  jmp alltraps
80106430:	e9 39 f7 ff ff       	jmp    80105b6e <alltraps>

80106435 <vector110>:
.globl vector110
vector110:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $110
80106437:	6a 6e                	push   $0x6e
  jmp alltraps
80106439:	e9 30 f7 ff ff       	jmp    80105b6e <alltraps>

8010643e <vector111>:
.globl vector111
vector111:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $111
80106440:	6a 6f                	push   $0x6f
  jmp alltraps
80106442:	e9 27 f7 ff ff       	jmp    80105b6e <alltraps>

80106447 <vector112>:
.globl vector112
vector112:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $112
80106449:	6a 70                	push   $0x70
  jmp alltraps
8010644b:	e9 1e f7 ff ff       	jmp    80105b6e <alltraps>

80106450 <vector113>:
.globl vector113
vector113:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $113
80106452:	6a 71                	push   $0x71
  jmp alltraps
80106454:	e9 15 f7 ff ff       	jmp    80105b6e <alltraps>

80106459 <vector114>:
.globl vector114
vector114:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $114
8010645b:	6a 72                	push   $0x72
  jmp alltraps
8010645d:	e9 0c f7 ff ff       	jmp    80105b6e <alltraps>

80106462 <vector115>:
.globl vector115
vector115:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $115
80106464:	6a 73                	push   $0x73
  jmp alltraps
80106466:	e9 03 f7 ff ff       	jmp    80105b6e <alltraps>

8010646b <vector116>:
.globl vector116
vector116:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $116
8010646d:	6a 74                	push   $0x74
  jmp alltraps
8010646f:	e9 fa f6 ff ff       	jmp    80105b6e <alltraps>

80106474 <vector117>:
.globl vector117
vector117:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $117
80106476:	6a 75                	push   $0x75
  jmp alltraps
80106478:	e9 f1 f6 ff ff       	jmp    80105b6e <alltraps>

8010647d <vector118>:
.globl vector118
vector118:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $118
8010647f:	6a 76                	push   $0x76
  jmp alltraps
80106481:	e9 e8 f6 ff ff       	jmp    80105b6e <alltraps>

80106486 <vector119>:
.globl vector119
vector119:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $119
80106488:	6a 77                	push   $0x77
  jmp alltraps
8010648a:	e9 df f6 ff ff       	jmp    80105b6e <alltraps>

8010648f <vector120>:
.globl vector120
vector120:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $120
80106491:	6a 78                	push   $0x78
  jmp alltraps
80106493:	e9 d6 f6 ff ff       	jmp    80105b6e <alltraps>

80106498 <vector121>:
.globl vector121
vector121:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $121
8010649a:	6a 79                	push   $0x79
  jmp alltraps
8010649c:	e9 cd f6 ff ff       	jmp    80105b6e <alltraps>

801064a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $122
801064a3:	6a 7a                	push   $0x7a
  jmp alltraps
801064a5:	e9 c4 f6 ff ff       	jmp    80105b6e <alltraps>

801064aa <vector123>:
.globl vector123
vector123:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $123
801064ac:	6a 7b                	push   $0x7b
  jmp alltraps
801064ae:	e9 bb f6 ff ff       	jmp    80105b6e <alltraps>

801064b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $124
801064b5:	6a 7c                	push   $0x7c
  jmp alltraps
801064b7:	e9 b2 f6 ff ff       	jmp    80105b6e <alltraps>

801064bc <vector125>:
.globl vector125
vector125:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $125
801064be:	6a 7d                	push   $0x7d
  jmp alltraps
801064c0:	e9 a9 f6 ff ff       	jmp    80105b6e <alltraps>

801064c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $126
801064c7:	6a 7e                	push   $0x7e
  jmp alltraps
801064c9:	e9 a0 f6 ff ff       	jmp    80105b6e <alltraps>

801064ce <vector127>:
.globl vector127
vector127:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $127
801064d0:	6a 7f                	push   $0x7f
  jmp alltraps
801064d2:	e9 97 f6 ff ff       	jmp    80105b6e <alltraps>

801064d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $128
801064d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064de:	e9 8b f6 ff ff       	jmp    80105b6e <alltraps>

801064e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $129
801064e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ea:	e9 7f f6 ff ff       	jmp    80105b6e <alltraps>

801064ef <vector130>:
.globl vector130
vector130:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $130
801064f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064f6:	e9 73 f6 ff ff       	jmp    80105b6e <alltraps>

801064fb <vector131>:
.globl vector131
vector131:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $131
801064fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106502:	e9 67 f6 ff ff       	jmp    80105b6e <alltraps>

80106507 <vector132>:
.globl vector132
vector132:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $132
80106509:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010650e:	e9 5b f6 ff ff       	jmp    80105b6e <alltraps>

80106513 <vector133>:
.globl vector133
vector133:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $133
80106515:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010651a:	e9 4f f6 ff ff       	jmp    80105b6e <alltraps>

8010651f <vector134>:
.globl vector134
vector134:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $134
80106521:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106526:	e9 43 f6 ff ff       	jmp    80105b6e <alltraps>

8010652b <vector135>:
.globl vector135
vector135:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $135
8010652d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106532:	e9 37 f6 ff ff       	jmp    80105b6e <alltraps>

80106537 <vector136>:
.globl vector136
vector136:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $136
80106539:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010653e:	e9 2b f6 ff ff       	jmp    80105b6e <alltraps>

80106543 <vector137>:
.globl vector137
vector137:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $137
80106545:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010654a:	e9 1f f6 ff ff       	jmp    80105b6e <alltraps>

8010654f <vector138>:
.globl vector138
vector138:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $138
80106551:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106556:	e9 13 f6 ff ff       	jmp    80105b6e <alltraps>

8010655b <vector139>:
.globl vector139
vector139:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $139
8010655d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106562:	e9 07 f6 ff ff       	jmp    80105b6e <alltraps>

80106567 <vector140>:
.globl vector140
vector140:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $140
80106569:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010656e:	e9 fb f5 ff ff       	jmp    80105b6e <alltraps>

80106573 <vector141>:
.globl vector141
vector141:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $141
80106575:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010657a:	e9 ef f5 ff ff       	jmp    80105b6e <alltraps>

8010657f <vector142>:
.globl vector142
vector142:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $142
80106581:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106586:	e9 e3 f5 ff ff       	jmp    80105b6e <alltraps>

8010658b <vector143>:
.globl vector143
vector143:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $143
8010658d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106592:	e9 d7 f5 ff ff       	jmp    80105b6e <alltraps>

80106597 <vector144>:
.globl vector144
vector144:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $144
80106599:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010659e:	e9 cb f5 ff ff       	jmp    80105b6e <alltraps>

801065a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $145
801065a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065aa:	e9 bf f5 ff ff       	jmp    80105b6e <alltraps>

801065af <vector146>:
.globl vector146
vector146:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $146
801065b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065b6:	e9 b3 f5 ff ff       	jmp    80105b6e <alltraps>

801065bb <vector147>:
.globl vector147
vector147:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $147
801065bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065c2:	e9 a7 f5 ff ff       	jmp    80105b6e <alltraps>

801065c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $148
801065c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065ce:	e9 9b f5 ff ff       	jmp    80105b6e <alltraps>

801065d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $149
801065d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065da:	e9 8f f5 ff ff       	jmp    80105b6e <alltraps>

801065df <vector150>:
.globl vector150
vector150:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $150
801065e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065e6:	e9 83 f5 ff ff       	jmp    80105b6e <alltraps>

801065eb <vector151>:
.globl vector151
vector151:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $151
801065ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065f2:	e9 77 f5 ff ff       	jmp    80105b6e <alltraps>

801065f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $152
801065f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065fe:	e9 6b f5 ff ff       	jmp    80105b6e <alltraps>

80106603 <vector153>:
.globl vector153
vector153:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $153
80106605:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010660a:	e9 5f f5 ff ff       	jmp    80105b6e <alltraps>

8010660f <vector154>:
.globl vector154
vector154:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $154
80106611:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106616:	e9 53 f5 ff ff       	jmp    80105b6e <alltraps>

8010661b <vector155>:
.globl vector155
vector155:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $155
8010661d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106622:	e9 47 f5 ff ff       	jmp    80105b6e <alltraps>

80106627 <vector156>:
.globl vector156
vector156:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $156
80106629:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010662e:	e9 3b f5 ff ff       	jmp    80105b6e <alltraps>

80106633 <vector157>:
.globl vector157
vector157:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $157
80106635:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010663a:	e9 2f f5 ff ff       	jmp    80105b6e <alltraps>

8010663f <vector158>:
.globl vector158
vector158:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $158
80106641:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106646:	e9 23 f5 ff ff       	jmp    80105b6e <alltraps>

8010664b <vector159>:
.globl vector159
vector159:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $159
8010664d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106652:	e9 17 f5 ff ff       	jmp    80105b6e <alltraps>

80106657 <vector160>:
.globl vector160
vector160:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $160
80106659:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010665e:	e9 0b f5 ff ff       	jmp    80105b6e <alltraps>

80106663 <vector161>:
.globl vector161
vector161:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $161
80106665:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010666a:	e9 ff f4 ff ff       	jmp    80105b6e <alltraps>

8010666f <vector162>:
.globl vector162
vector162:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $162
80106671:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106676:	e9 f3 f4 ff ff       	jmp    80105b6e <alltraps>

8010667b <vector163>:
.globl vector163
vector163:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $163
8010667d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106682:	e9 e7 f4 ff ff       	jmp    80105b6e <alltraps>

80106687 <vector164>:
.globl vector164
vector164:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $164
80106689:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010668e:	e9 db f4 ff ff       	jmp    80105b6e <alltraps>

80106693 <vector165>:
.globl vector165
vector165:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $165
80106695:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010669a:	e9 cf f4 ff ff       	jmp    80105b6e <alltraps>

8010669f <vector166>:
.globl vector166
vector166:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $166
801066a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066a6:	e9 c3 f4 ff ff       	jmp    80105b6e <alltraps>

801066ab <vector167>:
.globl vector167
vector167:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $167
801066ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066b2:	e9 b7 f4 ff ff       	jmp    80105b6e <alltraps>

801066b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $168
801066b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066be:	e9 ab f4 ff ff       	jmp    80105b6e <alltraps>

801066c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $169
801066c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066ca:	e9 9f f4 ff ff       	jmp    80105b6e <alltraps>

801066cf <vector170>:
.globl vector170
vector170:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $170
801066d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066d6:	e9 93 f4 ff ff       	jmp    80105b6e <alltraps>

801066db <vector171>:
.globl vector171
vector171:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $171
801066dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066e2:	e9 87 f4 ff ff       	jmp    80105b6e <alltraps>

801066e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $172
801066e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ee:	e9 7b f4 ff ff       	jmp    80105b6e <alltraps>

801066f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $173
801066f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066fa:	e9 6f f4 ff ff       	jmp    80105b6e <alltraps>

801066ff <vector174>:
.globl vector174
vector174:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $174
80106701:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106706:	e9 63 f4 ff ff       	jmp    80105b6e <alltraps>

8010670b <vector175>:
.globl vector175
vector175:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $175
8010670d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106712:	e9 57 f4 ff ff       	jmp    80105b6e <alltraps>

80106717 <vector176>:
.globl vector176
vector176:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $176
80106719:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010671e:	e9 4b f4 ff ff       	jmp    80105b6e <alltraps>

80106723 <vector177>:
.globl vector177
vector177:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $177
80106725:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010672a:	e9 3f f4 ff ff       	jmp    80105b6e <alltraps>

8010672f <vector178>:
.globl vector178
vector178:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $178
80106731:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106736:	e9 33 f4 ff ff       	jmp    80105b6e <alltraps>

8010673b <vector179>:
.globl vector179
vector179:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $179
8010673d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106742:	e9 27 f4 ff ff       	jmp    80105b6e <alltraps>

80106747 <vector180>:
.globl vector180
vector180:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $180
80106749:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010674e:	e9 1b f4 ff ff       	jmp    80105b6e <alltraps>

80106753 <vector181>:
.globl vector181
vector181:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $181
80106755:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010675a:	e9 0f f4 ff ff       	jmp    80105b6e <alltraps>

8010675f <vector182>:
.globl vector182
vector182:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $182
80106761:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106766:	e9 03 f4 ff ff       	jmp    80105b6e <alltraps>

8010676b <vector183>:
.globl vector183
vector183:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $183
8010676d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106772:	e9 f7 f3 ff ff       	jmp    80105b6e <alltraps>

80106777 <vector184>:
.globl vector184
vector184:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $184
80106779:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010677e:	e9 eb f3 ff ff       	jmp    80105b6e <alltraps>

80106783 <vector185>:
.globl vector185
vector185:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $185
80106785:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010678a:	e9 df f3 ff ff       	jmp    80105b6e <alltraps>

8010678f <vector186>:
.globl vector186
vector186:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $186
80106791:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106796:	e9 d3 f3 ff ff       	jmp    80105b6e <alltraps>

8010679b <vector187>:
.globl vector187
vector187:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $187
8010679d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067a2:	e9 c7 f3 ff ff       	jmp    80105b6e <alltraps>

801067a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $188
801067a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067ae:	e9 bb f3 ff ff       	jmp    80105b6e <alltraps>

801067b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $189
801067b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ba:	e9 af f3 ff ff       	jmp    80105b6e <alltraps>

801067bf <vector190>:
.globl vector190
vector190:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $190
801067c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067c6:	e9 a3 f3 ff ff       	jmp    80105b6e <alltraps>

801067cb <vector191>:
.globl vector191
vector191:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $191
801067cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067d2:	e9 97 f3 ff ff       	jmp    80105b6e <alltraps>

801067d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $192
801067d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067de:	e9 8b f3 ff ff       	jmp    80105b6e <alltraps>

801067e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $193
801067e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ea:	e9 7f f3 ff ff       	jmp    80105b6e <alltraps>

801067ef <vector194>:
.globl vector194
vector194:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $194
801067f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067f6:	e9 73 f3 ff ff       	jmp    80105b6e <alltraps>

801067fb <vector195>:
.globl vector195
vector195:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $195
801067fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106802:	e9 67 f3 ff ff       	jmp    80105b6e <alltraps>

80106807 <vector196>:
.globl vector196
vector196:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $196
80106809:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010680e:	e9 5b f3 ff ff       	jmp    80105b6e <alltraps>

80106813 <vector197>:
.globl vector197
vector197:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $197
80106815:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010681a:	e9 4f f3 ff ff       	jmp    80105b6e <alltraps>

8010681f <vector198>:
.globl vector198
vector198:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $198
80106821:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106826:	e9 43 f3 ff ff       	jmp    80105b6e <alltraps>

8010682b <vector199>:
.globl vector199
vector199:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $199
8010682d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106832:	e9 37 f3 ff ff       	jmp    80105b6e <alltraps>

80106837 <vector200>:
.globl vector200
vector200:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $200
80106839:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010683e:	e9 2b f3 ff ff       	jmp    80105b6e <alltraps>

80106843 <vector201>:
.globl vector201
vector201:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $201
80106845:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010684a:	e9 1f f3 ff ff       	jmp    80105b6e <alltraps>

8010684f <vector202>:
.globl vector202
vector202:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $202
80106851:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106856:	e9 13 f3 ff ff       	jmp    80105b6e <alltraps>

8010685b <vector203>:
.globl vector203
vector203:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $203
8010685d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106862:	e9 07 f3 ff ff       	jmp    80105b6e <alltraps>

80106867 <vector204>:
.globl vector204
vector204:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $204
80106869:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010686e:	e9 fb f2 ff ff       	jmp    80105b6e <alltraps>

80106873 <vector205>:
.globl vector205
vector205:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $205
80106875:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010687a:	e9 ef f2 ff ff       	jmp    80105b6e <alltraps>

8010687f <vector206>:
.globl vector206
vector206:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $206
80106881:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106886:	e9 e3 f2 ff ff       	jmp    80105b6e <alltraps>

8010688b <vector207>:
.globl vector207
vector207:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $207
8010688d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106892:	e9 d7 f2 ff ff       	jmp    80105b6e <alltraps>

80106897 <vector208>:
.globl vector208
vector208:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $208
80106899:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010689e:	e9 cb f2 ff ff       	jmp    80105b6e <alltraps>

801068a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $209
801068a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068aa:	e9 bf f2 ff ff       	jmp    80105b6e <alltraps>

801068af <vector210>:
.globl vector210
vector210:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $210
801068b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068b6:	e9 b3 f2 ff ff       	jmp    80105b6e <alltraps>

801068bb <vector211>:
.globl vector211
vector211:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $211
801068bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068c2:	e9 a7 f2 ff ff       	jmp    80105b6e <alltraps>

801068c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $212
801068c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068ce:	e9 9b f2 ff ff       	jmp    80105b6e <alltraps>

801068d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $213
801068d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068da:	e9 8f f2 ff ff       	jmp    80105b6e <alltraps>

801068df <vector214>:
.globl vector214
vector214:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $214
801068e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068e6:	e9 83 f2 ff ff       	jmp    80105b6e <alltraps>

801068eb <vector215>:
.globl vector215
vector215:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $215
801068ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068f2:	e9 77 f2 ff ff       	jmp    80105b6e <alltraps>

801068f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $216
801068f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068fe:	e9 6b f2 ff ff       	jmp    80105b6e <alltraps>

80106903 <vector217>:
.globl vector217
vector217:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $217
80106905:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010690a:	e9 5f f2 ff ff       	jmp    80105b6e <alltraps>

8010690f <vector218>:
.globl vector218
vector218:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $218
80106911:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106916:	e9 53 f2 ff ff       	jmp    80105b6e <alltraps>

8010691b <vector219>:
.globl vector219
vector219:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $219
8010691d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106922:	e9 47 f2 ff ff       	jmp    80105b6e <alltraps>

80106927 <vector220>:
.globl vector220
vector220:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $220
80106929:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010692e:	e9 3b f2 ff ff       	jmp    80105b6e <alltraps>

80106933 <vector221>:
.globl vector221
vector221:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $221
80106935:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010693a:	e9 2f f2 ff ff       	jmp    80105b6e <alltraps>

8010693f <vector222>:
.globl vector222
vector222:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $222
80106941:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106946:	e9 23 f2 ff ff       	jmp    80105b6e <alltraps>

8010694b <vector223>:
.globl vector223
vector223:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $223
8010694d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106952:	e9 17 f2 ff ff       	jmp    80105b6e <alltraps>

80106957 <vector224>:
.globl vector224
vector224:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $224
80106959:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010695e:	e9 0b f2 ff ff       	jmp    80105b6e <alltraps>

80106963 <vector225>:
.globl vector225
vector225:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $225
80106965:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010696a:	e9 ff f1 ff ff       	jmp    80105b6e <alltraps>

8010696f <vector226>:
.globl vector226
vector226:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $226
80106971:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106976:	e9 f3 f1 ff ff       	jmp    80105b6e <alltraps>

8010697b <vector227>:
.globl vector227
vector227:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $227
8010697d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106982:	e9 e7 f1 ff ff       	jmp    80105b6e <alltraps>

80106987 <vector228>:
.globl vector228
vector228:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $228
80106989:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010698e:	e9 db f1 ff ff       	jmp    80105b6e <alltraps>

80106993 <vector229>:
.globl vector229
vector229:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $229
80106995:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010699a:	e9 cf f1 ff ff       	jmp    80105b6e <alltraps>

8010699f <vector230>:
.globl vector230
vector230:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $230
801069a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069a6:	e9 c3 f1 ff ff       	jmp    80105b6e <alltraps>

801069ab <vector231>:
.globl vector231
vector231:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $231
801069ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069b2:	e9 b7 f1 ff ff       	jmp    80105b6e <alltraps>

801069b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $232
801069b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069be:	e9 ab f1 ff ff       	jmp    80105b6e <alltraps>

801069c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $233
801069c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069ca:	e9 9f f1 ff ff       	jmp    80105b6e <alltraps>

801069cf <vector234>:
.globl vector234
vector234:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $234
801069d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069d6:	e9 93 f1 ff ff       	jmp    80105b6e <alltraps>

801069db <vector235>:
.globl vector235
vector235:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $235
801069dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069e2:	e9 87 f1 ff ff       	jmp    80105b6e <alltraps>

801069e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $236
801069e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ee:	e9 7b f1 ff ff       	jmp    80105b6e <alltraps>

801069f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $237
801069f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069fa:	e9 6f f1 ff ff       	jmp    80105b6e <alltraps>

801069ff <vector238>:
.globl vector238
vector238:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $238
80106a01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a06:	e9 63 f1 ff ff       	jmp    80105b6e <alltraps>

80106a0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $239
80106a0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a12:	e9 57 f1 ff ff       	jmp    80105b6e <alltraps>

80106a17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $240
80106a19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a1e:	e9 4b f1 ff ff       	jmp    80105b6e <alltraps>

80106a23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $241
80106a25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a2a:	e9 3f f1 ff ff       	jmp    80105b6e <alltraps>

80106a2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $242
80106a31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a36:	e9 33 f1 ff ff       	jmp    80105b6e <alltraps>

80106a3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $243
80106a3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a42:	e9 27 f1 ff ff       	jmp    80105b6e <alltraps>

80106a47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $244
80106a49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a4e:	e9 1b f1 ff ff       	jmp    80105b6e <alltraps>

80106a53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $245
80106a55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a5a:	e9 0f f1 ff ff       	jmp    80105b6e <alltraps>

80106a5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $246
80106a61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a66:	e9 03 f1 ff ff       	jmp    80105b6e <alltraps>

80106a6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $247
80106a6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a72:	e9 f7 f0 ff ff       	jmp    80105b6e <alltraps>

80106a77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $248
80106a79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a7e:	e9 eb f0 ff ff       	jmp    80105b6e <alltraps>

80106a83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $249
80106a85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a8a:	e9 df f0 ff ff       	jmp    80105b6e <alltraps>

80106a8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $250
80106a91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a96:	e9 d3 f0 ff ff       	jmp    80105b6e <alltraps>

80106a9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $251
80106a9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106aa2:	e9 c7 f0 ff ff       	jmp    80105b6e <alltraps>

80106aa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $252
80106aa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106aae:	e9 bb f0 ff ff       	jmp    80105b6e <alltraps>

80106ab3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $253
80106ab5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aba:	e9 af f0 ff ff       	jmp    80105b6e <alltraps>

80106abf <vector254>:
.globl vector254
vector254:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $254
80106ac1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ac6:	e9 a3 f0 ff ff       	jmp    80105b6e <alltraps>

80106acb <vector255>:
.globl vector255
vector255:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $255
80106acd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ad2:	e9 97 f0 ff ff       	jmp    80105b6e <alltraps>
80106ad7:	66 90                	xchg   %ax,%ax
80106ad9:	66 90                	xchg   %ax,%ax
80106adb:	66 90                	xchg   %ax,%ax
80106add:	66 90                	xchg   %ax,%ax
80106adf:	90                   	nop

80106ae0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ae6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106aec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af2:	83 ec 1c             	sub    $0x1c,%esp
80106af5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106af8:	39 d3                	cmp    %edx,%ebx
80106afa:	73 49                	jae    80106b45 <deallocuvm.part.0+0x65>
80106afc:	89 c7                	mov    %eax,%edi
80106afe:	eb 0c                	jmp    80106b0c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b00:	83 c0 01             	add    $0x1,%eax
80106b03:	c1 e0 16             	shl    $0x16,%eax
80106b06:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b08:	39 da                	cmp    %ebx,%edx
80106b0a:	76 39                	jbe    80106b45 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b0c:	89 d8                	mov    %ebx,%eax
80106b0e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b11:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b14:	f6 c1 01             	test   $0x1,%cl
80106b17:	74 e7                	je     80106b00 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b19:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b1b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b21:	c1 ee 0a             	shr    $0xa,%esi
80106b24:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b2a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106b31:	85 f6                	test   %esi,%esi
80106b33:	74 cb                	je     80106b00 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b35:	8b 06                	mov    (%esi),%eax
80106b37:	a8 01                	test   $0x1,%al
80106b39:	75 15                	jne    80106b50 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b41:	39 da                	cmp    %ebx,%edx
80106b43:	77 c7                	ja     80106b0c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b4b:	5b                   	pop    %ebx
80106b4c:	5e                   	pop    %esi
80106b4d:	5f                   	pop    %edi
80106b4e:	5d                   	pop    %ebp
80106b4f:	c3                   	ret    
      if(pa == 0)
80106b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b55:	74 25                	je     80106b7c <deallocuvm.part.0+0x9c>
      kfree(v);
80106b57:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b5a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b62:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b68:	50                   	push   %eax
80106b69:	e8 52 b9 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106b6e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106b74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b77:	83 c4 10             	add    $0x10,%esp
80106b7a:	eb 8c                	jmp    80106b08 <deallocuvm.part.0+0x28>
        panic("kfree");
80106b7c:	83 ec 0c             	sub    $0xc,%esp
80106b7f:	68 46 77 10 80       	push   $0x80107746
80106b84:	e8 f7 97 ff ff       	call   80100380 <panic>
80106b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b90 <mappages>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b96:	89 d3                	mov    %edx,%ebx
80106b98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b9e:	83 ec 1c             	sub    $0x1c,%esp
80106ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ba4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ba8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bad:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb3:	29 d8                	sub    %ebx,%eax
80106bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bb8:	eb 3d                	jmp    80106bf7 <mappages+0x67>
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bc0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bc7:	c1 ea 0a             	shr    $0xa,%edx
80106bca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bd0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bd7:	85 c0                	test   %eax,%eax
80106bd9:	74 75                	je     80106c50 <mappages+0xc0>
    if(*pte & PTE_P)
80106bdb:	f6 00 01             	testb  $0x1,(%eax)
80106bde:	0f 85 86 00 00 00    	jne    80106c6a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106be4:	0b 75 0c             	or     0xc(%ebp),%esi
80106be7:	83 ce 01             	or     $0x1,%esi
80106bea:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bec:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106bef:	74 6f                	je     80106c60 <mappages+0xd0>
    a += PGSIZE;
80106bf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106bfa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bfd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c00:	89 d8                	mov    %ebx,%eax
80106c02:	c1 e8 16             	shr    $0x16,%eax
80106c05:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c08:	8b 07                	mov    (%edi),%eax
80106c0a:	a8 01                	test   $0x1,%al
80106c0c:	75 b2                	jne    80106bc0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c0e:	e8 6d ba ff ff       	call   80102680 <kalloc>
80106c13:	85 c0                	test   %eax,%eax
80106c15:	74 39                	je     80106c50 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c17:	83 ec 04             	sub    $0x4,%esp
80106c1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c1d:	68 00 10 00 00       	push   $0x1000
80106c22:	6a 00                	push   $0x0
80106c24:	50                   	push   %eax
80106c25:	e8 e6 dc ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c2a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c2d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c30:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c36:	83 c8 07             	or     $0x7,%eax
80106c39:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c3b:	89 d8                	mov    %ebx,%eax
80106c3d:	c1 e8 0a             	shr    $0xa,%eax
80106c40:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c45:	01 d0                	add    %edx,%eax
80106c47:	eb 92                	jmp    80106bdb <mappages+0x4b>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c58:	5b                   	pop    %ebx
80106c59:	5e                   	pop    %esi
80106c5a:	5f                   	pop    %edi
80106c5b:	5d                   	pop    %ebp
80106c5c:	c3                   	ret    
80106c5d:	8d 76 00             	lea    0x0(%esi),%esi
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
      panic("remap");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 f0 7d 10 80       	push   $0x80107df0
80106c72:	e8 09 97 ff ff       	call   80100380 <panic>
80106c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <seginit>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c86:	e8 c5 cc ff ff       	call   80103950 <cpuid>
  pd[0] = size-1;
80106c8b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c90:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c9a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106ca1:	ff 00 00 
80106ca4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106cab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cae:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106cb5:	ff 00 00 
80106cb8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106cbf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cc2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106cc9:	ff 00 00 
80106ccc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106cd3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cd6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106cdd:	ff 00 00 
80106ce0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106ce7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cea:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106cef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cf3:	c1 e8 10             	shr    $0x10,%eax
80106cf6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cfa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cfd:	0f 01 10             	lgdtl  (%eax)
}
80106d00:	c9                   	leave  
80106d01:	c3                   	ret    
80106d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d10:	a1 c4 45 11 80       	mov    0x801145c4,%eax
80106d15:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d1a:	0f 22 d8             	mov    %eax,%cr3
}
80106d1d:	c3                   	ret    
80106d1e:	66 90                	xchg   %ax,%ax

80106d20 <switchuvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d2c:	85 f6                	test   %esi,%esi
80106d2e:	0f 84 cb 00 00 00    	je     80106dff <switchuvm+0xdf>
  if(p->kstack == 0)
80106d34:	8b 46 08             	mov    0x8(%esi),%eax
80106d37:	85 c0                	test   %eax,%eax
80106d39:	0f 84 da 00 00 00    	je     80106e19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d3f:	8b 46 04             	mov    0x4(%esi),%eax
80106d42:	85 c0                	test   %eax,%eax
80106d44:	0f 84 c2 00 00 00    	je     80106e0c <switchuvm+0xec>
  pushcli();
80106d4a:	e8 b1 d9 ff ff       	call   80104700 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d4f:	e8 9c cb ff ff       	call   801038f0 <mycpu>
80106d54:	89 c3                	mov    %eax,%ebx
80106d56:	e8 95 cb ff ff       	call   801038f0 <mycpu>
80106d5b:	89 c7                	mov    %eax,%edi
80106d5d:	e8 8e cb ff ff       	call   801038f0 <mycpu>
80106d62:	83 c7 08             	add    $0x8,%edi
80106d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d68:	e8 83 cb ff ff       	call   801038f0 <mycpu>
80106d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d70:	ba 67 00 00 00       	mov    $0x67,%edx
80106d75:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d7c:	83 c0 08             	add    $0x8,%eax
80106d7f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d86:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d8b:	83 c1 08             	add    $0x8,%ecx
80106d8e:	c1 e8 18             	shr    $0x18,%eax
80106d91:	c1 e9 10             	shr    $0x10,%ecx
80106d94:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d9a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106da0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106da5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106db1:	e8 3a cb ff ff       	call   801038f0 <mycpu>
80106db6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbd:	e8 2e cb ff ff       	call   801038f0 <mycpu>
80106dc2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dc6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dcf:	e8 1c cb ff ff       	call   801038f0 <mycpu>
80106dd4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dd7:	e8 14 cb ff ff       	call   801038f0 <mycpu>
80106ddc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106de0:	b8 28 00 00 00       	mov    $0x28,%eax
80106de5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106de8:	8b 46 04             	mov    0x4(%esi),%eax
80106deb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106df0:	0f 22 d8             	mov    %eax,%cr3
}
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	5b                   	pop    %ebx
80106df7:	5e                   	pop    %esi
80106df8:	5f                   	pop    %edi
80106df9:	5d                   	pop    %ebp
  popcli();
80106dfa:	e9 51 d9 ff ff       	jmp    80104750 <popcli>
    panic("switchuvm: no process");
80106dff:	83 ec 0c             	sub    $0xc,%esp
80106e02:	68 f6 7d 10 80       	push   $0x80107df6
80106e07:	e8 74 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	68 21 7e 10 80       	push   $0x80107e21
80106e14:	e8 67 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e19:	83 ec 0c             	sub    $0xc,%esp
80106e1c:	68 0c 7e 10 80       	push   $0x80107e0c
80106e21:	e8 5a 95 ff ff       	call   80100380 <panic>
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi

80106e30 <inituvm>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
80106e39:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e3c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e3f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e45:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e4b:	77 4b                	ja     80106e98 <inituvm+0x68>
  mem = kalloc();
80106e4d:	e8 2e b8 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106e52:	83 ec 04             	sub    $0x4,%esp
80106e55:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e5a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e5c:	6a 00                	push   $0x0
80106e5e:	50                   	push   %eax
80106e5f:	e8 ac da ff ff       	call   80104910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e64:	58                   	pop    %eax
80106e65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e6b:	5a                   	pop    %edx
80106e6c:	6a 06                	push   $0x6
80106e6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e73:	31 d2                	xor    %edx,%edx
80106e75:	50                   	push   %eax
80106e76:	89 f8                	mov    %edi,%eax
80106e78:	e8 13 fd ff ff       	call   80106b90 <mappages>
  memmove(mem, init, sz);
80106e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e80:	89 75 10             	mov    %esi,0x10(%ebp)
80106e83:	83 c4 10             	add    $0x10,%esp
80106e86:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e89:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8f:	5b                   	pop    %ebx
80106e90:	5e                   	pop    %esi
80106e91:	5f                   	pop    %edi
80106e92:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e93:	e9 18 db ff ff       	jmp    801049b0 <memmove>
    panic("inituvm: more than a page");
80106e98:	83 ec 0c             	sub    $0xc,%esp
80106e9b:	68 35 7e 10 80       	push   $0x80107e35
80106ea0:	e8 db 94 ff ff       	call   80100380 <panic>
80106ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <loaduvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ebc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ebf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ec4:	0f 85 bb 00 00 00    	jne    80106f85 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eca:	01 f0                	add    %esi,%eax
80106ecc:	89 f3                	mov    %esi,%ebx
80106ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ed1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ed4:	01 f0                	add    %esi,%eax
80106ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ed9:	85 f6                	test   %esi,%esi
80106edb:	0f 84 87 00 00 00    	je     80106f68 <loaduvm+0xb8>
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106eee:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106ef0:	89 c2                	mov    %eax,%edx
80106ef2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ef5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106ef8:	f6 c2 01             	test   $0x1,%dl
80106efb:	75 13                	jne    80106f10 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106efd:	83 ec 0c             	sub    $0xc,%esp
80106f00:	68 4f 7e 10 80       	push   $0x80107e4f
80106f05:	e8 76 94 ff ff       	call   80100380 <panic>
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f10:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f13:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f19:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f1e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f25:	85 c0                	test   %eax,%eax
80106f27:	74 d4                	je     80106efd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f29:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f2e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f38:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f3e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f41:	29 d9                	sub    %ebx,%ecx
80106f43:	05 00 00 00 80       	add    $0x80000000,%eax
80106f48:	57                   	push   %edi
80106f49:	51                   	push   %ecx
80106f4a:	50                   	push   %eax
80106f4b:	ff 75 10             	push   0x10(%ebp)
80106f4e:	e8 3d ab ff ff       	call   80101a90 <readi>
80106f53:	83 c4 10             	add    $0x10,%esp
80106f56:	39 f8                	cmp    %edi,%eax
80106f58:	75 1e                	jne    80106f78 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f5a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f60:	89 f0                	mov    %esi,%eax
80106f62:	29 d8                	sub    %ebx,%eax
80106f64:	39 c6                	cmp    %eax,%esi
80106f66:	77 80                	ja     80106ee8 <loaduvm+0x38>
}
80106f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f6b:	31 c0                	xor    %eax,%eax
}
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
80106f71:	c3                   	ret    
80106f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f80:	5b                   	pop    %ebx
80106f81:	5e                   	pop    %esi
80106f82:	5f                   	pop    %edi
80106f83:	5d                   	pop    %ebp
80106f84:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f85:	83 ec 0c             	sub    $0xc,%esp
80106f88:	68 f0 7e 10 80       	push   $0x80107ef0
80106f8d:	e8 ee 93 ff ff       	call   80100380 <panic>
80106f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <allocuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fa9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fac:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106faf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fb2:	85 c0                	test   %eax,%eax
80106fb4:	0f 88 b6 00 00 00    	js     80107070 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fba:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fc0:	0f 82 9a 00 00 00    	jb     80107060 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fc6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fcc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fd2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fd5:	77 44                	ja     8010701b <allocuvm+0x7b>
80106fd7:	e9 87 00 00 00       	jmp    80107063 <allocuvm+0xc3>
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
80106fe3:	68 00 10 00 00       	push   $0x1000
80106fe8:	6a 00                	push   $0x0
80106fea:	50                   	push   %eax
80106feb:	e8 20 d9 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ff0:	58                   	pop    %eax
80106ff1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ff7:	5a                   	pop    %edx
80106ff8:	6a 06                	push   $0x6
80106ffa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fff:	89 f2                	mov    %esi,%edx
80107001:	50                   	push   %eax
80107002:	89 f8                	mov    %edi,%eax
80107004:	e8 87 fb ff ff       	call   80106b90 <mappages>
80107009:	83 c4 10             	add    $0x10,%esp
8010700c:	85 c0                	test   %eax,%eax
8010700e:	78 78                	js     80107088 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107010:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107016:	39 75 10             	cmp    %esi,0x10(%ebp)
80107019:	76 48                	jbe    80107063 <allocuvm+0xc3>
    mem = kalloc();
8010701b:	e8 60 b6 ff ff       	call   80102680 <kalloc>
80107020:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107022:	85 c0                	test   %eax,%eax
80107024:	75 ba                	jne    80106fe0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107026:	83 ec 0c             	sub    $0xc,%esp
80107029:	68 6d 7e 10 80       	push   $0x80107e6d
8010702e:	e8 6d 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107033:	8b 45 0c             	mov    0xc(%ebp),%eax
80107036:	83 c4 10             	add    $0x10,%esp
80107039:	39 45 10             	cmp    %eax,0x10(%ebp)
8010703c:	74 32                	je     80107070 <allocuvm+0xd0>
8010703e:	8b 55 10             	mov    0x10(%ebp),%edx
80107041:	89 c1                	mov    %eax,%ecx
80107043:	89 f8                	mov    %edi,%eax
80107045:	e8 96 fa ff ff       	call   80106ae0 <deallocuvm.part.0>
      return 0;
8010704a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107054:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107057:	5b                   	pop    %ebx
80107058:	5e                   	pop    %esi
80107059:	5f                   	pop    %edi
8010705a:	5d                   	pop    %ebp
8010705b:	c3                   	ret    
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107060:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107069:	5b                   	pop    %ebx
8010706a:	5e                   	pop    %esi
8010706b:	5f                   	pop    %edi
8010706c:	5d                   	pop    %ebp
8010706d:	c3                   	ret    
8010706e:	66 90                	xchg   %ax,%ax
    return 0;
80107070:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010707a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010707d:	5b                   	pop    %ebx
8010707e:	5e                   	pop    %esi
8010707f:	5f                   	pop    %edi
80107080:	5d                   	pop    %ebp
80107081:	c3                   	ret    
80107082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107088:	83 ec 0c             	sub    $0xc,%esp
8010708b:	68 85 7e 10 80       	push   $0x80107e85
80107090:	e8 0b 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107095:	8b 45 0c             	mov    0xc(%ebp),%eax
80107098:	83 c4 10             	add    $0x10,%esp
8010709b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010709e:	74 0c                	je     801070ac <allocuvm+0x10c>
801070a0:	8b 55 10             	mov    0x10(%ebp),%edx
801070a3:	89 c1                	mov    %eax,%ecx
801070a5:	89 f8                	mov    %edi,%eax
801070a7:	e8 34 fa ff ff       	call   80106ae0 <deallocuvm.part.0>
      kfree(mem);
801070ac:	83 ec 0c             	sub    $0xc,%esp
801070af:	53                   	push   %ebx
801070b0:	e8 0b b4 ff ff       	call   801024c0 <kfree>
      return 0;
801070b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070bc:	83 c4 10             	add    $0x10,%esp
}
801070bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c5:	5b                   	pop    %ebx
801070c6:	5e                   	pop    %esi
801070c7:	5f                   	pop    %edi
801070c8:	5d                   	pop    %ebp
801070c9:	c3                   	ret    
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070d0 <deallocuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070dc:	39 d1                	cmp    %edx,%ecx
801070de:	73 10                	jae    801070f0 <deallocuvm+0x20>
}
801070e0:	5d                   	pop    %ebp
801070e1:	e9 fa f9 ff ff       	jmp    80106ae0 <deallocuvm.part.0>
801070e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ed:	8d 76 00             	lea    0x0(%esi),%esi
801070f0:	89 d0                	mov    %edx,%eax
801070f2:	5d                   	pop    %ebp
801070f3:	c3                   	ret    
801070f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ff:	90                   	nop

80107100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
80107109:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010710c:	85 f6                	test   %esi,%esi
8010710e:	74 59                	je     80107169 <freevm+0x69>
  if(newsz >= oldsz)
80107110:	31 c9                	xor    %ecx,%ecx
80107112:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107117:	89 f0                	mov    %esi,%eax
80107119:	89 f3                	mov    %esi,%ebx
8010711b:	e8 c0 f9 ff ff       	call   80106ae0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107120:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107126:	eb 0f                	jmp    80107137 <freevm+0x37>
80107128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712f:	90                   	nop
80107130:	83 c3 04             	add    $0x4,%ebx
80107133:	39 df                	cmp    %ebx,%edi
80107135:	74 23                	je     8010715a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107137:	8b 03                	mov    (%ebx),%eax
80107139:	a8 01                	test   $0x1,%al
8010713b:	74 f3                	je     80107130 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010713d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107142:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107145:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107148:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010714d:	50                   	push   %eax
8010714e:	e8 6d b3 ff ff       	call   801024c0 <kfree>
80107153:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107156:	39 df                	cmp    %ebx,%edi
80107158:	75 dd                	jne    80107137 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010715a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010715d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107160:	5b                   	pop    %ebx
80107161:	5e                   	pop    %esi
80107162:	5f                   	pop    %edi
80107163:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107164:	e9 57 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 a1 7e 10 80       	push   $0x80107ea1
80107171:	e8 0a 92 ff ff       	call   80100380 <panic>
80107176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717d:	8d 76 00             	lea    0x0(%esi),%esi

80107180 <setupkvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	56                   	push   %esi
80107184:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107185:	e8 f6 b4 ff ff       	call   80102680 <kalloc>
8010718a:	89 c6                	mov    %eax,%esi
8010718c:	85 c0                	test   %eax,%eax
8010718e:	74 42                	je     801071d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107193:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107198:	68 00 10 00 00       	push   $0x1000
8010719d:	6a 00                	push   $0x0
8010719f:	50                   	push   %eax
801071a0:	e8 6b d7 ff ff       	call   80104910 <memset>
801071a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071ab:	83 ec 08             	sub    $0x8,%esp
801071ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071b1:	ff 73 0c             	push   0xc(%ebx)
801071b4:	8b 13                	mov    (%ebx),%edx
801071b6:	50                   	push   %eax
801071b7:	29 c1                	sub    %eax,%ecx
801071b9:	89 f0                	mov    %esi,%eax
801071bb:	e8 d0 f9 ff ff       	call   80106b90 <mappages>
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 19                	js     801071e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071c7:	83 c3 10             	add    $0x10,%ebx
801071ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071d0:	75 d6                	jne    801071a8 <setupkvm+0x28>
}
801071d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d5:	89 f0                	mov    %esi,%eax
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5d                   	pop    %ebp
801071da:	c3                   	ret    
801071db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071df:	90                   	nop
      freevm(pgdir);
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	56                   	push   %esi
      return 0;
801071e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071e6:	e8 15 ff ff ff       	call   80107100 <freevm>
      return 0;
801071eb:	83 c4 10             	add    $0x10,%esp
}
801071ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f1:	89 f0                	mov    %esi,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5d                   	pop    %ebp
801071f6:	c3                   	ret    
801071f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fe:	66 90                	xchg   %ax,%ax

80107200 <kvmalloc>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107206:	e8 75 ff ff ff       	call   80107180 <setupkvm>
8010720b:	a3 c4 45 11 80       	mov    %eax,0x801145c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	05 00 00 00 80       	add    $0x80000000,%eax
80107215:	0f 22 d8             	mov    %eax,%cr3
}
80107218:	c9                   	leave  
80107219:	c3                   	ret    
8010721a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107220 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	83 ec 08             	sub    $0x8,%esp
80107226:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107229:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010722c:	89 c1                	mov    %eax,%ecx
8010722e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107231:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107234:	f6 c2 01             	test   $0x1,%dl
80107237:	75 17                	jne    80107250 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 b2 7e 10 80       	push   $0x80107eb2
80107241:	e8 3a 91 ff ff       	call   80100380 <panic>
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107250:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107253:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107259:	25 fc 0f 00 00       	and    $0xffc,%eax
8010725e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107265:	85 c0                	test   %eax,%eax
80107267:	74 d0                	je     80107239 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107269:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010726c:	c9                   	leave  
8010726d:	c3                   	ret    
8010726e:	66 90                	xchg   %ax,%ax

80107270 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107279:	e8 02 ff ff ff       	call   80107180 <setupkvm>
8010727e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107281:	85 c0                	test   %eax,%eax
80107283:	0f 84 bd 00 00 00    	je     80107346 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010728c:	85 c9                	test   %ecx,%ecx
8010728e:	0f 84 b2 00 00 00    	je     80107346 <copyuvm+0xd6>
80107294:	31 f6                	xor    %esi,%esi
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801072a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072a3:	89 f0                	mov    %esi,%eax
801072a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072ab:	a8 01                	test   $0x1,%al
801072ad:	75 11                	jne    801072c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072af:	83 ec 0c             	sub    $0xc,%esp
801072b2:	68 bc 7e 10 80       	push   $0x80107ebc
801072b7:	e8 c4 90 ff ff       	call   80100380 <panic>
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072c7:	c1 ea 0a             	shr    $0xa,%edx
801072ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072d7:	85 c0                	test   %eax,%eax
801072d9:	74 d4                	je     801072af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072db:	8b 00                	mov    (%eax),%eax
801072dd:	a8 01                	test   $0x1,%al
801072df:	0f 84 9f 00 00 00    	je     80107384 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072e5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801072ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801072f5:	e8 86 b3 ff ff       	call   80102680 <kalloc>
801072fa:	89 c3                	mov    %eax,%ebx
801072fc:	85 c0                	test   %eax,%eax
801072fe:	74 64                	je     80107364 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107300:	83 ec 04             	sub    $0x4,%esp
80107303:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107309:	68 00 10 00 00       	push   $0x1000
8010730e:	57                   	push   %edi
8010730f:	50                   	push   %eax
80107310:	e8 9b d6 ff ff       	call   801049b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107315:	58                   	pop    %eax
80107316:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010731c:	5a                   	pop    %edx
8010731d:	ff 75 e4             	push   -0x1c(%ebp)
80107320:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107325:	89 f2                	mov    %esi,%edx
80107327:	50                   	push   %eax
80107328:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010732b:	e8 60 f8 ff ff       	call   80106b90 <mappages>
80107330:	83 c4 10             	add    $0x10,%esp
80107333:	85 c0                	test   %eax,%eax
80107335:	78 21                	js     80107358 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107337:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010733d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107340:	0f 87 5a ff ff ff    	ja     801072a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107346:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107349:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734c:	5b                   	pop    %ebx
8010734d:	5e                   	pop    %esi
8010734e:	5f                   	pop    %edi
8010734f:	5d                   	pop    %ebp
80107350:	c3                   	ret    
80107351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107358:	83 ec 0c             	sub    $0xc,%esp
8010735b:	53                   	push   %ebx
8010735c:	e8 5f b1 ff ff       	call   801024c0 <kfree>
      goto bad;
80107361:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107364:	83 ec 0c             	sub    $0xc,%esp
80107367:	ff 75 e0             	push   -0x20(%ebp)
8010736a:	e8 91 fd ff ff       	call   80107100 <freevm>
  return 0;
8010736f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107376:	83 c4 10             	add    $0x10,%esp
}
80107379:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010737c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010737f:	5b                   	pop    %ebx
80107380:	5e                   	pop    %esi
80107381:	5f                   	pop    %edi
80107382:	5d                   	pop    %ebp
80107383:	c3                   	ret    
      panic("copyuvm: page not present");
80107384:	83 ec 0c             	sub    $0xc,%esp
80107387:	68 d6 7e 10 80       	push   $0x80107ed6
8010738c:	e8 ef 8f ff ff       	call   80100380 <panic>
80107391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop

801073a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073a9:	89 c1                	mov    %eax,%ecx
801073ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073b1:	f6 c2 01             	test   $0x1,%dl
801073b4:	0f 84 00 01 00 00    	je     801074ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801073ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073da:	05 00 00 00 80       	add    $0x80000000,%eax
801073df:	83 fa 05             	cmp    $0x5,%edx
801073e2:	ba 00 00 00 00       	mov    $0x0,%edx
801073e7:	0f 45 c2             	cmovne %edx,%eax
}
801073ea:	c3                   	ret    
801073eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ef:	90                   	nop

801073f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	8b 75 14             	mov    0x14(%ebp),%esi
801073fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801073ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107402:	85 f6                	test   %esi,%esi
80107404:	75 51                	jne    80107457 <copyout+0x67>
80107406:	e9 a5 00 00 00       	jmp    801074b0 <copyout+0xc0>
8010740b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010740f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107410:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107416:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010741c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107422:	74 75                	je     80107499 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107424:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107426:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107429:	29 c3                	sub    %eax,%ebx
8010742b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107431:	39 f3                	cmp    %esi,%ebx
80107433:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107436:	29 f8                	sub    %edi,%eax
80107438:	83 ec 04             	sub    $0x4,%esp
8010743b:	01 c1                	add    %eax,%ecx
8010743d:	53                   	push   %ebx
8010743e:	52                   	push   %edx
8010743f:	51                   	push   %ecx
80107440:	e8 6b d5 ff ff       	call   801049b0 <memmove>
    len -= n;
    buf += n;
80107445:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107448:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010744e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107451:	01 da                	add    %ebx,%edx
  while(len > 0){
80107453:	29 de                	sub    %ebx,%esi
80107455:	74 59                	je     801074b0 <copyout+0xc0>
  if(*pde & PTE_P){
80107457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010745a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010745c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010745e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107461:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107467:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010746a:	f6 c1 01             	test   $0x1,%cl
8010746d:	0f 84 4e 00 00 00    	je     801074c1 <copyout.cold>
  return &pgtab[PTX(va)];
80107473:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107475:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010747b:	c1 eb 0c             	shr    $0xc,%ebx
8010747e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107484:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010748b:	89 d9                	mov    %ebx,%ecx
8010748d:	83 e1 05             	and    $0x5,%ecx
80107490:	83 f9 05             	cmp    $0x5,%ecx
80107493:	0f 84 77 ff ff ff    	je     80107410 <copyout+0x20>
  }
  return 0;
}
80107499:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010749c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074a1:	5b                   	pop    %ebx
801074a2:	5e                   	pop    %esi
801074a3:	5f                   	pop    %edi
801074a4:	5d                   	pop    %ebp
801074a5:	c3                   	ret    
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
801074b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074b3:	31 c0                	xor    %eax,%eax
}
801074b5:	5b                   	pop    %ebx
801074b6:	5e                   	pop    %esi
801074b7:	5f                   	pop    %edi
801074b8:	5d                   	pop    %ebp
801074b9:	c3                   	ret    

801074ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801074ba:	a1 00 00 00 00       	mov    0x0,%eax
801074bf:	0f 0b                	ud2    

801074c1 <copyout.cold>:
801074c1:	a1 00 00 00 00       	mov    0x0,%eax
801074c6:	0f 0b                	ud2    
