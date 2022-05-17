
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 82 10 80       	push   $0x80108280
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 b1 52 00 00       	call   80105310 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 82 10 80       	push   $0x80108287
80100097:	50                   	push   %eax
80100098:	e8 33 51 00 00       	call   801051d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 a3 53 00 00       	call   80105490 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 e9 53 00 00       	call   80105550 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 50 00 00       	call   80105210 <acquiresleep>
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
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 8e 82 10 80       	push   $0x8010828e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 e9 50 00 00       	call   801052b0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 82 10 80       	push   $0x8010829f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 a8 50 00 00       	call   801052b0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 50 00 00       	call   80105270 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 6c 52 00 00       	call   80105490 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 db 52 00 00       	jmp    80105550 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 82 10 80       	push   $0x801082a6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 da 51 00 00       	call   80105490 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 06 40 00 00       	call   801042f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 36 00 00       	call   801039e0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 3d 52 00 00       	call   80105550 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 e6 51 00 00       	call   80105550 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 82 10 80       	push   $0x801082ad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 b6 88 10 80 	movl   $0x801088b6,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 4f 4f 00 00       	call   80105330 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 82 10 80       	push   $0x801082c1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 51 6a 00 00       	call   80106e80 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 66 69 00 00       	call   80106e80 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 5a 69 00 00       	call   80106e80 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 4e 69 00 00       	call   80106e80 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 50 00 00       	call   80105640 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 50 00 00       	call   801055a0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 82 10 80       	push   $0x801082c5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 f0 82 10 80 	movzbl -0x7fef7d10(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 2c 4e 00 00       	call   80105490 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 b4 4e 00 00       	call   80105550 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb d8 82 10 80       	mov    $0x801082d8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 ce 4c 00 00       	call   80105490 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 23 4d 00 00       	call   80105550 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 82 10 80       	push   $0x801082df
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 14 4c 00 00       	call   80105490 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 7c 4b 00 00       	call   80105550 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 ac 3b 00 00       	jmp    801045b0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 8b 3a 00 00       	call   801044b0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 e8 82 10 80       	push   $0x801082e8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 c7 48 00 00       	call   80105310 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 4b 2f 00 00       	call   801039e0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 08 03 00 00    	je     80100dbe <exec+0x33e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 df 74 00 00       	call   80107ff0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ae 02 00 00    	je     80100ddd <exec+0x35d>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 98 72 00 00       	call   80107e10 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 92 71 00 00       	call   80107d40 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 80 73 00 00       	call   80107f70 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 d9 71 00 00       	call   80107e10 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 38 74 00 00       	call   80108090 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 f8 4a 00 00       	call   801057a0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 e5 4a 00 00       	call   801057a0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 24 75 00 00       	call   801081f0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 8a 72 00 00       	call   80107f70 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 b8 74 00 00       	call   801081f0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 ea 49 00 00       	call   80105760 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->q_num = ROUND_ROBIN_QUEUE;
80100d9a:	c7 81 e4 00 00 00 01 	movl   $0x1,0xe4(%ecx)
80100da1:	00 00 00 
  switchuvm(curproc);
80100da4:	89 0c 24             	mov    %ecx,(%esp)
80100da7:	e8 04 6e 00 00       	call   80107bb0 <switchuvm>
  freevm(oldpgdir);
80100dac:	89 3c 24             	mov    %edi,(%esp)
80100daf:	e8 bc 71 00 00       	call   80107f70 <freevm>
  return 0;
80100db4:	83 c4 10             	add    $0x10,%esp
80100db7:	31 c0                	xor    %eax,%eax
80100db9:	e9 32 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbe:	e8 ed 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc3:	83 ec 0c             	sub    $0xc,%esp
80100dc6:	68 01 83 10 80       	push   $0x80108301
80100dcb:	e8 e0 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dd0:	83 c4 10             	add    $0x10,%esp
80100dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd8:	e9 13 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddd:	31 ff                	xor    %edi,%edi
80100ddf:	be 00 20 00 00       	mov    $0x2000,%esi
80100de4:	e9 2f fe ff ff       	jmp    80100c18 <exec+0x198>
80100de9:	66 90                	xchg   %ax,%ax
80100deb:	66 90                	xchg   %ax,%ax
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 0d 83 10 80       	push   $0x8010830d
80100dff:	68 c0 0f 11 80       	push   $0x80110fc0
80100e04:	e8 07 45 00 00       	call   80105310 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 0f 11 80       	push   $0x80110fc0
80100e25:	e8 66 46 00 00       	call   80105490 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 fa 46 00 00       	call   80105550 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 0f 11 80       	push   $0x80110fc0
80100e6a:	e8 e1 46 00 00       	call   80105550 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e93:	e8 f8 45 00 00       	call   80105490 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb0:	e8 9b 46 00 00       	call   80105550 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 14 83 10 80       	push   $0x80108314
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee5:	e8 a6 45 00 00       	call   80105490 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 2b 46 00 00       	call   80105550 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 fd 45 00 00       	jmp    80105550 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 1c 83 10 80       	push   $0x8010831c
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 26 83 10 80       	push   $0x80108326
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 2f 83 10 80       	push   $0x8010832f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 35 83 10 80       	push   $0x80108335
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
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
801011c8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
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
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
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
80101227:	68 3f 83 10 80       	push   $0x8010833f
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
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
80101249:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
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
8010126c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 19 11 80       	mov    0x801119c0,%eax
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
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 52 83 10 80       	push   $0x80108352
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
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
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
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
80101325:	e8 76 42 00 00       	call   801055a0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
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
8010135a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 21 41 00 00       	call   80105490 <acquire>
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
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
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
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 74 41 00 00       	call   80105550 <release>

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
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 46 41 00 00       	call   80105550 <release>
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
80101417:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 68 83 10 80       	push   $0x80108368
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 78 83 10 80       	push   $0x80108378
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 06 41 00 00       	call   80105640 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 8b 83 10 80       	push   $0x8010838b
80101565:	68 e0 19 11 80       	push   $0x801119e0
8010156a:	e8 a1 3d 00 00       	call   80105310 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 92 83 10 80       	push   $0x80108392
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 44 3c 00 00       	call   801051d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 19 11 80       	push   $0x801119c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015ad:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015b3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015b9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015bf:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015c5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015cb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015d1:	68 f8 83 10 80       	push   $0x801083f8
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 2d 3f 00 00       	call   801055a0 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 98 83 10 80       	push   $0x80108398
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 26 3f 00 00       	call   80105640 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 19 11 80       	push   $0x801119e0
80101753:	e8 38 3d 00 00       	call   80105490 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101763:	e8 e8 3d 00 00       	call   80105550 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 75 3a 00 00       	call   80105210 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 33 3e 00 00       	call   80105640 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 b0 83 10 80       	push   $0x801083b0
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 aa 83 10 80       	push   $0x801083aa
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 44 3a 00 00       	call   801052b0 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 e8 39 00 00       	jmp    80105270 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 bf 83 10 80       	push   $0x801083bf
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 57 39 00 00       	call   80105210 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 9d 39 00 00       	call   80105270 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018da:	e8 b1 3b 00 00       	call   80105490 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 57 3c 00 00       	jmp    80105550 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 19 11 80       	push   $0x801119e0
80101908:	e8 83 3b 00 00       	call   80105490 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101917:	e8 34 3c 00 00       	call   80105550 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 24 3b 00 00       	call   80105640 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 28 3a 00 00       	call   80105640 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 f9 39 00 00       	call   801056b0 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 96 39 00 00       	call   801056b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 d9 83 10 80       	push   $0x801083d9
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 c7 83 10 80       	push   $0x801083c7
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 41 1c 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 19 11 80       	push   $0x801119e0
80101dac:	e8 df 36 00 00       	call   80105490 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dbc:	e8 8f 37 00 00       	call   80105550 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 14 38 00 00       	call   80105640 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 88 37 00 00       	call   80105640 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 16 37 00 00       	call   80105700 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 e8 83 10 80       	push   $0x801083e8
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 e2 8b 10 80       	push   $0x80108be2
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 54 84 10 80       	push   $0x80108454
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 4b 84 10 80       	push   $0x8010844b
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 66 84 10 80       	push   $0x80108466
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 97 31 00 00       	call   80105310 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 b5 10 80       	push   $0x8010b580
80102202:	e8 89 32 00 00       	call   80105490 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 4e 22 00 00       	call   801044b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 b5 10 80       	push   $0x8010b580
8010227b:	e8 d0 32 00 00       	call   80105550 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 09 30 00 00       	call   801052b0 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 b5 10 80       	push   $0x8010b580
801022dc:	e8 af 31 00 00       	call   80105490 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 b5 10 80       	push   $0x8010b580
80102328:	53                   	push   %ebx
80102329:	e8 c2 1f 00 00       	call   801042f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 05 32 00 00       	jmp    80105550 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 95 84 10 80       	push   $0x80108495
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 80 84 10 80       	push   $0x80108480
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 6a 84 10 80       	push   $0x8010846a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 b4 84 10 80       	push   $0x801084b4
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 88 11 80    	cmp    $0x801188a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 e5 30 00 00       	call   801055a0 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 36 11 80       	push   $0x80113640
801024f0:	e8 9b 2f 00 00       	call   80105490 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 40 30 00 00       	jmp    80105550 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 e6 84 10 80       	push   $0x801084e6
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 ec 84 10 80       	push   $0x801084ec
80102584:	68 40 36 11 80       	push   $0x80113640
80102589:	e8 82 2d 00 00       	call   80105310 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 36 11 80       	mov    0x80113674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 36 11 80       	push   $0x80113640
80102673:	e8 18 2e 00 00       	call   80105490 <acquire>
  r = kmem.freelist;
80102678:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010267d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 36 11 80       	push   $0x80113640
801026a1:	e8 aa 2e 00 00       	call   80105550 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a 20 86 10 80 	movzbl -0x7fef79e0(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 20 85 10 80 	movzbl -0x7fef7ae0(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 00 85 10 80 	mov    -0x7fef7b00(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a 20 86 10 80 	movzbl -0x7fef79e0(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 1c 2b 00 00       	call   801055f0 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102be4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 37 2a 00 00       	call   80105640 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c4d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 20 87 10 80       	push   $0x80108720
80102cb3:	68 80 36 11 80       	push   $0x80113680
80102cb8:	e8 53 26 00 00       	call   80105310 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 36 11 80       	push   $0x80113680
80102d4f:	e8 3c 27 00 00       	call   80105490 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 36 11 80       	push   $0x80113680
80102d68:	68 80 36 11 80       	push   $0x80113680
80102d6d:	e8 7e 15 00 00       	call   801042f0 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d83:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d9f:	68 80 36 11 80       	push   $0x80113680
80102da4:	e8 a7 27 00 00       	call   80105550 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 36 11 80       	push   $0x80113680
80102dc2:	e8 c9 26 00 00       	call   80105490 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 36 11 80       	push   $0x80113680
80102e00:	e8 4b 27 00 00       	call   80105550 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 36 11 80       	push   $0x80113680
80102e1a:	e8 71 26 00 00       	call   80105490 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 7b 16 00 00       	call   801044b0 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e3c:	e8 0f 27 00 00       	call   80105550 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e74:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 a7 27 00 00       	call   80105640 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 36 11 80       	push   $0x80113680
80102ee8:	e8 c3 15 00 00       	call   801044b0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ef4:	e8 57 26 00 00       	call   80105550 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 24 87 10 80       	push   $0x80108724
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 36 11 80       	push   $0x80113680
80102f62:	e8 29 25 00 00       	call   80105490 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 a6 25 00 00       	jmp    80105550 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 33 87 10 80       	push   $0x80108733
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 49 87 10 80       	push   $0x80108749
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 c4 09 00 00       	call   801039c0 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 bd 09 00 00       	call   801039c0 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 64 87 10 80       	push   $0x80108764
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 a9 3a 00 00       	call   80106ac0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 34 09 00 00       	call   80103950 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 71 0f 00 00       	call   80103fa0 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 51 4b 00 00       	call   80107b90 <switchkvm>
  seginit();
8010303f:	e8 bc 4a 00 00       	call   80107b00 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 88 11 80       	push   $0x801188a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 f6 4f 00 00       	call   80108070 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 77 4a 00 00       	call   80107b00 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 23 3d 00 00       	call   80106dc0 <uartinit>
  pinit();         // process table
8010309d:	e8 8e 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 99 39 00 00       	call   80106a40 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c b4 10 80       	push   $0x8010b48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 73 25 00 00       	call   80105640 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030d7:	00 00 00 
801030da:	05 80 37 11 80       	add    $0x80113780,%eax
801030df:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 37 11 80       	add    $0x80113780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 42 08 00 00       	call   80103950 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010312b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 99 08 00 00       	call   80103a10 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 78 87 10 80       	push   $0x80108778
801031b3:	56                   	push   %esi
801031b4:	e8 37 24 00 00       	call   801055f0 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 7d 87 10 80       	push   $0x8010877d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 78 23 00 00       	call   801055f0 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 82 87 10 80       	push   $0x80108782
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 9c 87 10 80       	push   $0x8010879c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 bb 87 10 80       	push   $0x801087bb
8010347c:	50                   	push   %eax
8010347d:	e8 8e 1e 00 00       	call   80105310 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 68 1f 00 00       	call   80105490 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 68 0f 00 00       	call   801044b0 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 e3 1f 00 00       	jmp    80105550 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 27 0f 00 00       	call   801044b0 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 b7 1f 00 00       	call   80105550 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 ca 1e 00 00       	call   80105490 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 d3 03 00 00       	call   801039e0 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 93 0e 00 00       	call   801044b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 ca 0c 00 00       	call   801042f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 ff 1e 00 00       	call   80105550 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 11 0e 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 a9 1e 00 00       	call   80105550 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 c1 1d 00 00       	call   80105490 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 f3 02 00 00       	call   801039e0 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 ee 0b 00 00       	call   801042f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 45 0d 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 dd 1d 00 00       	call   80105550 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 c2 1d 00 00       	call   80105550 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 3d 11 80       	push   $0x80113d20
801037b1:	e8 da 1c 00 00       	call   80105490 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
801037c6:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
801037cc:	0f 84 de 00 00 00    	je     801038b0 <allocproc+0x110>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  return 0;

found:
  p->state = EMBRYO;
  p->q_num = FCFS_QUEUE;
  p->waited_cycles = 0;
801037d9:	d9 ee                	fldz   
  p->executed_cycles = 0;
  acquire(&tickslock);
801037db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->waited_cycles = 0;
801037e5:	d9 93 e8 00 00 00    	fsts   0xe8(%ebx)
  p->executed_cycles = 0;
801037eb:	d9 9b ec 00 00 00    	fstps  0xec(%ebx)
  p->q_num = FCFS_QUEUE;
801037f1:	c7 83 e4 00 00 00 02 	movl   $0x2,0xe4(%ebx)
801037f8:	00 00 00 
  acquire(&tickslock);
801037fb:	68 60 80 11 80       	push   $0x80118060
80103800:	e8 8b 1c 00 00       	call   80105490 <acquire>
  p->arrival_time = ticks;
80103805:	a1 a0 88 11 80       	mov    0x801188a0,%eax
8010380a:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
  release(&tickslock);
80103810:	c7 04 24 60 80 11 80 	movl   $0x80118060,(%esp)
80103817:	e8 34 1d 00 00       	call   80105550 <release>
  p->tickets = 10;
  p->priority_ratio = 1;
  p->arrival_time_ratio = 1;
  p->executed_cycles_ratio = 1;
  p->pid = nextpid++;
8010381c:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->tickets = 10;
80103821:	c7 83 fc 00 00 00 0a 	movl   $0xa,0xfc(%ebx)
80103828:	00 00 00 
  p->priority_ratio = 1;
8010382b:	c7 83 00 01 00 00 01 	movl   $0x1,0x100(%ebx)
80103832:	00 00 00 
  p->pid = nextpid++;
80103835:	89 43 10             	mov    %eax,0x10(%ebx)
80103838:	8d 50 01             	lea    0x1(%eax),%edx
  p->arrival_time_ratio = 1;
8010383b:	c7 83 04 01 00 00 01 	movl   $0x1,0x104(%ebx)
80103842:	00 00 00 
  p->executed_cycles_ratio = 1;
80103845:	c7 83 08 01 00 00 01 	movl   $0x1,0x108(%ebx)
8010384c:	00 00 00 
  p->pid = nextpid++;
8010384f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103855:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010385c:	e8 ef 1c 00 00       	call   80105550 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103861:	e8 da ed ff ff       	call   80102640 <kalloc>
80103866:	83 c4 10             	add    $0x10,%esp
80103869:	89 43 08             	mov    %eax,0x8(%ebx)
8010386c:	85 c0                	test   %eax,%eax
8010386e:	74 59                	je     801038c9 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103870:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103876:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103879:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010387e:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103881:	c7 40 14 2b 6a 10 80 	movl   $0x80106a2b,0x14(%eax)
  p->context = (struct context*)sp;
80103888:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010388b:	6a 14                	push   $0x14
8010388d:	6a 00                	push   $0x0
8010388f:	50                   	push   %eax
80103890:	e8 0b 1d 00 00       	call   801055a0 <memset>
  p->context->eip = (uint)forkret;
80103895:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103898:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010389b:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 20 3d 11 80       	push   $0x80113d20
801038ba:	e8 91 1c 00 00       	call   80105550 <release>
}
801038bf:	89 d8                	mov    %ebx,%eax
  return 0;
801038c1:	83 c4 10             	add    $0x10,%esp
}
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038d0:	31 db                	xor    %ebx,%ebx
}
801038d2:	89 d8                	mov    %ebx,%eax
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ea:	68 20 3d 11 80       	push   $0x80113d20
801038ef:	e8 5c 1c 00 00       	call   80105550 <release>

  if (first) {
801038f4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	85 c0                	test   %eax,%eax
801038fe:	75 08                	jne    80103908 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103900:	c9                   	leave  
80103901:	c3                   	ret    
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103908:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010390f:	00 00 00 
    iinit(ROOTDEV);
80103912:	83 ec 0c             	sub    $0xc,%esp
80103915:	6a 01                	push   $0x1
80103917:	e8 34 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
8010391c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103923:	e8 78 f3 ff ff       	call   80102ca0 <initlog>
}
80103928:	83 c4 10             	add    $0x10,%esp
8010392b:	c9                   	leave  
8010392c:	c3                   	ret    
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <pinit>:
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010393a:	68 c0 87 10 80       	push   $0x801087c0
8010393f:	68 20 3d 11 80       	push   $0x80113d20
80103944:	e8 c7 19 00 00       	call   80105310 <initlock>
}
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	c9                   	leave  
8010394d:	c3                   	ret    
8010394e:	66 90                	xchg   %ax,%ax

80103950 <mycpu>:
{
80103950:	f3 0f 1e fb          	endbr32 
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	56                   	push   %esi
80103958:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103959:	9c                   	pushf  
8010395a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010395b:	f6 c4 02             	test   $0x2,%ah
8010395e:	75 4a                	jne    801039aa <mycpu+0x5a>
  apicid = lapicid();
80103960:	e8 4b ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103965:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010396b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010396d:	85 f6                	test   %esi,%esi
8010396f:	7e 2c                	jle    8010399d <mycpu+0x4d>
80103971:	31 d2                	xor    %edx,%edx
80103973:	eb 0a                	jmp    8010397f <mycpu+0x2f>
80103975:	8d 76 00             	lea    0x0(%esi),%esi
80103978:	83 c2 01             	add    $0x1,%edx
8010397b:	39 f2                	cmp    %esi,%edx
8010397d:	74 1e                	je     8010399d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010397f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103985:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
8010398c:	39 d8                	cmp    %ebx,%eax
8010398e:	75 e8                	jne    80103978 <mycpu+0x28>
}
80103990:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103993:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103999:	5b                   	pop    %ebx
8010399a:	5e                   	pop    %esi
8010399b:	5d                   	pop    %ebp
8010399c:	c3                   	ret    
  panic("unknown apicid\n");
8010399d:	83 ec 0c             	sub    $0xc,%esp
801039a0:	68 c7 87 10 80       	push   $0x801087c7
801039a5:	e8 e6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	68 54 89 10 80       	push   $0x80108954
801039b2:	e8 d9 c9 ff ff       	call   80100390 <panic>
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax

801039c0 <cpuid>:
cpuid() {
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039ca:	e8 81 ff ff ff       	call   80103950 <mycpu>
}
801039cf:	c9                   	leave  
  return mycpu()-cpus;
801039d0:	2d 80 37 11 80       	sub    $0x80113780,%eax
801039d5:	c1 f8 04             	sar    $0x4,%eax
801039d8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039de:	c3                   	ret    
801039df:	90                   	nop

801039e0 <myproc>:
myproc(void) {
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039eb:	e8 a0 19 00 00       	call   80105390 <pushcli>
  c = mycpu();
801039f0:	e8 5b ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
801039f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039fb:	e8 e0 19 00 00       	call   801053e0 <popcli>
}
80103a00:	83 c4 04             	add    $0x4,%esp
80103a03:	89 d8                	mov    %ebx,%eax
80103a05:	5b                   	pop    %ebx
80103a06:	5d                   	pop    %ebp
80103a07:	c3                   	ret    
80103a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <userinit>:
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	53                   	push   %ebx
80103a18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a1b:	e8 80 fd ff ff       	call   801037a0 <allocproc>
80103a20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a22:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a27:	e8 c4 45 00 00       	call   80107ff0 <setupkvm>
80103a2c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a2f:	85 c0                	test   %eax,%eax
80103a31:	0f 84 bd 00 00 00    	je     80103af4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a37:	83 ec 04             	sub    $0x4,%esp
80103a3a:	68 2c 00 00 00       	push   $0x2c
80103a3f:	68 60 b4 10 80       	push   $0x8010b460
80103a44:	50                   	push   %eax
80103a45:	e8 76 42 00 00       	call   80107cc0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a4d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a53:	6a 4c                	push   $0x4c
80103a55:	6a 00                	push   $0x0
80103a57:	ff 73 18             	pushl  0x18(%ebx)
80103a5a:	e8 41 1b 00 00       	call   801055a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a67:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a6a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a73:	8b 43 18             	mov    0x18(%ebx),%eax
80103a76:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a7a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a81:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a85:	8b 43 18             	mov    0x18(%ebx),%eax
80103a88:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a8c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103aa4:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aae:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ab1:	6a 10                	push   $0x10
80103ab3:	68 f0 87 10 80       	push   $0x801087f0
80103ab8:	50                   	push   %eax
80103ab9:	e8 a2 1c 00 00       	call   80105760 <safestrcpy>
  p->cwd = namei("/");
80103abe:	c7 04 24 f9 87 10 80 	movl   $0x801087f9,(%esp)
80103ac5:	e8 76 e5 ff ff       	call   80102040 <namei>
80103aca:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103acd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ad4:	e8 b7 19 00 00       	call   80105490 <acquire>
  p->state = RUNNABLE;
80103ad9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ae0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ae7:	e8 64 1a 00 00       	call   80105550 <release>
}
80103aec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	c9                   	leave  
80103af3:	c3                   	ret    
    panic("userinit: out of memory?");
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	68 d7 87 10 80       	push   $0x801087d7
80103afc:	e8 8f c8 ff ff       	call   80100390 <panic>
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop

80103b10 <growproc>:
{
80103b10:	f3 0f 1e fb          	endbr32 
80103b14:	55                   	push   %ebp
80103b15:	89 e5                	mov    %esp,%ebp
80103b17:	56                   	push   %esi
80103b18:	53                   	push   %ebx
80103b19:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b1c:	e8 6f 18 00 00       	call   80105390 <pushcli>
  c = mycpu();
80103b21:	e8 2a fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b26:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b2c:	e8 af 18 00 00       	call   801053e0 <popcli>
  sz = curproc->sz;
80103b31:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b33:	85 f6                	test   %esi,%esi
80103b35:	7f 19                	jg     80103b50 <growproc+0x40>
  } else if(n < 0){
80103b37:	75 37                	jne    80103b70 <growproc+0x60>
  switchuvm(curproc);
80103b39:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b3c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b3e:	53                   	push   %ebx
80103b3f:	e8 6c 40 00 00       	call   80107bb0 <switchuvm>
  return 0;
80103b44:	83 c4 10             	add    $0x10,%esp
80103b47:	31 c0                	xor    %eax,%eax
}
80103b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b4c:	5b                   	pop    %ebx
80103b4d:	5e                   	pop    %esi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	pushl  0x4(%ebx)
80103b5a:	e8 b1 42 00 00       	call   80107e10 <allocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 d3                	jne    80103b39 <growproc+0x29>
      return -1;
80103b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b6b:	eb dc                	jmp    80103b49 <growproc+0x39>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	83 ec 04             	sub    $0x4,%esp
80103b73:	01 c6                	add    %eax,%esi
80103b75:	56                   	push   %esi
80103b76:	50                   	push   %eax
80103b77:	ff 73 04             	pushl  0x4(%ebx)
80103b7a:	e8 c1 43 00 00       	call   80107f40 <deallocuvm>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 b3                	jne    80103b39 <growproc+0x29>
80103b86:	eb de                	jmp    80103b66 <growproc+0x56>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <fork>:
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	57                   	push   %edi
80103b98:	56                   	push   %esi
80103b99:	53                   	push   %ebx
80103b9a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b9d:	e8 ee 17 00 00       	call   80105390 <pushcli>
  c = mycpu();
80103ba2:	e8 a9 fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103ba7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bad:	e8 2e 18 00 00       	call   801053e0 <popcli>
  if((np= allocproc()) == 0){
80103bb2:	e8 e9 fb ff ff       	call   801037a0 <allocproc>
80103bb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	0f 84 e7 00 00 00    	je     80103ca9 <fork+0x119>
  if (curproc->name[0] == 's' && curproc->name[1] == 'h' && curproc->name[2] == 0)
80103bc2:	66 81 7b 6c 73 68    	cmpw   $0x6873,0x6c(%ebx)
80103bc8:	0f 84 c2 00 00 00    	je     80103c90 <fork+0x100>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bce:	83 ec 08             	sub    $0x8,%esp
80103bd1:	ff 33                	pushl  (%ebx)
80103bd3:	ff 73 04             	pushl  0x4(%ebx)
80103bd6:	e8 e5 44 00 00       	call   801080c0 <copyuvm>
80103bdb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bde:	83 c4 10             	add    $0x10,%esp
80103be1:	89 41 04             	mov    %eax,0x4(%ecx)
80103be4:	85 c0                	test   %eax,%eax
80103be6:	0f 84 c4 00 00 00    	je     80103cb0 <fork+0x120>
  np->sz = curproc->sz;
80103bec:	8b 03                	mov    (%ebx),%eax
80103bee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bf1:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bf3:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bf6:	89 c8                	mov    %ecx,%eax
80103bf8:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bfb:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c00:	8b 73 18             	mov    0x18(%ebx),%esi
80103c03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c05:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c07:	8b 40 18             	mov    0x18(%eax),%eax
80103c0a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c18:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	74 13                	je     80103c33 <fork+0xa3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	50                   	push   %eax
80103c24:	e8 57 d2 ff ff       	call   80100e80 <filedup>
80103c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c2c:	83 c4 10             	add    $0x10,%esp
80103c2f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c33:	83 c6 01             	add    $0x1,%esi
80103c36:	83 fe 10             	cmp    $0x10,%esi
80103c39:	75 dd                	jne    80103c18 <fork+0x88>
  np->cwd = idup(curproc->cwd);
80103c3b:	83 ec 0c             	sub    $0xc,%esp
80103c3e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c41:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c44:	e8 f7 da ff ff       	call   80101740 <idup>
80103c49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c4c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c4f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c52:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c55:	6a 10                	push   $0x10
80103c57:	53                   	push   %ebx
80103c58:	50                   	push   %eax
80103c59:	e8 02 1b 00 00       	call   80105760 <safestrcpy>
  pid = np->pid;
80103c5e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c61:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c68:	e8 23 18 00 00       	call   80105490 <acquire>
  np->state = RUNNABLE;
80103c6d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c74:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c7b:	e8 d0 18 00 00       	call   80105550 <release>
  return pid;
80103c80:	83 c4 10             	add    $0x10,%esp
}
80103c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c86:	89 d8                	mov    %ebx,%eax
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5f                   	pop    %edi
80103c8b:	5d                   	pop    %ebp
80103c8c:	c3                   	ret    
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
  if (curproc->name[0] == 's' && curproc->name[1] == 'h' && curproc->name[2] == 0)
80103c90:	80 7b 6e 00          	cmpb   $0x0,0x6e(%ebx)
80103c94:	0f 85 34 ff ff ff    	jne    80103bce <fork+0x3e>
    np->q_num = ROUND_ROBIN_QUEUE;
80103c9a:	c7 80 e4 00 00 00 01 	movl   $0x1,0xe4(%eax)
80103ca1:	00 00 00 
80103ca4:	e9 25 ff ff ff       	jmp    80103bce <fork+0x3e>
    return -1;
80103ca9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cae:	eb d3                	jmp    80103c83 <fork+0xf3>
    kfree(np->kstack);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	ff 71 08             	pushl  0x8(%ecx)
80103cb6:	89 cf                	mov    %ecx,%edi
    return -1;
80103cb8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103cbd:	e8 be e7 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103cc2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103cc9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ccc:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103cd3:	eb ae                	jmp    80103c83 <fork+0xf3>
80103cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <get_old>:
{
80103ce0:	f3 0f 1e fb          	endbr32 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce4:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ce9:	eb 11                	jmp    80103cfc <get_old+0x1c>
80103ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop
80103cf0:	05 0c 01 00 00       	add    $0x10c,%eax
80103cf5:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80103cfa:	74 48                	je     80103d44 <get_old+0x64>
    if(p->state == RUNNABLE && p->waited_cycles > 8000)
80103cfc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d00:	75 ee                	jne    80103cf0 <get_old+0x10>
80103d02:	d9 05 c0 8a 10 80    	flds   0x80108ac0
80103d08:	d9 80 e8 00 00 00    	flds   0xe8(%eax)
80103d0e:	df f1                	fcomip %st(1),%st
80103d10:	dd d8                	fstp   %st(0)
80103d12:	76 dc                	jbe    80103cf0 <get_old+0x10>
      p->waited_cycles = 0;
80103d14:	c7 80 e8 00 00 00 00 	movl   $0x0,0xe8(%eax)
80103d1b:	00 00 00 
      if (p->q_num == FCFS_QUEUE)
80103d1e:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
80103d24:	83 fa 02             	cmp    $0x2,%edx
80103d27:	74 1f                	je     80103d48 <get_old+0x68>
      else if(p->q_num == BJF_QUEUE)
80103d29:	83 fa 03             	cmp    $0x3,%edx
80103d2c:	75 c2                	jne    80103cf0 <get_old+0x10>
        p->q_num = FCFS_QUEUE;
80103d2e:	c7 80 e4 00 00 00 02 	movl   $0x2,0xe4(%eax)
80103d35:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d38:	05 0c 01 00 00       	add    $0x10c,%eax
80103d3d:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80103d42:	75 b8                	jne    80103cfc <get_old+0x1c>
}
80103d44:	c3                   	ret    
80103d45:	8d 76 00             	lea    0x0(%esi),%esi
        p->q_num = ROUND_ROBIN_QUEUE;
80103d48:	c7 80 e4 00 00 00 01 	movl   $0x1,0xe4(%eax)
80103d4f:	00 00 00 
80103d52:	eb 9c                	jmp    80103cf0 <get_old+0x10>
80103d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <round_robin>:
{
80103d60:	f3 0f 1e fb          	endbr32 
  for(p = ptable.prev_proc; p < &ptable.proc[NPROC]; p++){
80103d64:	8b 15 54 80 11 80    	mov    0x80118054,%edx
80103d6a:	81 fa 54 80 11 80    	cmp    $0x80118054,%edx
80103d70:	73 3a                	jae    80103dac <round_robin+0x4c>
80103d72:	89 d0                	mov    %edx,%eax
    if(p->state != RUNNABLE || p->q_num != ROUND_ROBIN_QUEUE)
80103d74:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d78:	75 26                	jne    80103da0 <round_robin+0x40>
80103d7a:	83 b8 e4 00 00 00 01 	cmpl   $0x1,0xe4(%eax)
80103d81:	75 1d                	jne    80103da0 <round_robin+0x40>
      ptable.prev_proc = p + 1;
80103d83:	8d 90 0c 01 00 00    	lea    0x10c(%eax),%edx
80103d89:	3d 48 7f 11 80       	cmp    $0x80117f48,%eax
80103d8e:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
80103d93:	0f 43 d1             	cmovae %ecx,%edx
80103d96:	89 15 54 80 11 80    	mov    %edx,0x80118054
80103d9c:	c3                   	ret    
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.prev_proc; p < &ptable.proc[NPROC]; p++){
80103da0:	05 0c 01 00 00       	add    $0x10c,%eax
80103da5:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80103daa:	72 c8                	jb     80103d74 <round_robin+0x14>
  for(p = ptable.proc; p < ptable.prev_proc; p++){
80103dac:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103db1:	39 c2                	cmp    %eax,%edx
80103db3:	76 18                	jbe    80103dcd <round_robin+0x6d>
    if(p->state != RUNNABLE || p->q_num != ROUND_ROBIN_QUEUE)
80103db5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103db9:	75 09                	jne    80103dc4 <round_robin+0x64>
80103dbb:	83 b8 e4 00 00 00 01 	cmpl   $0x1,0xe4(%eax)
80103dc2:	74 bf                	je     80103d83 <round_robin+0x23>
  for(p = ptable.proc; p < ptable.prev_proc; p++){
80103dc4:	05 0c 01 00 00       	add    $0x10c,%eax
80103dc9:	39 c2                	cmp    %eax,%edx
80103dcb:	77 e8                	ja     80103db5 <round_robin+0x55>
  return p;
80103dcd:	31 c0                	xor    %eax,%eax
}
80103dcf:	c3                   	ret    

80103dd0 <fcfs>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
  int mn = 2e9;
80103dd5:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dda:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
80103ddf:	89 e5                	mov    %esp,%ebp
80103de1:	53                   	push   %ebx
  struct proc *first_proc = 0;
80103de2:	31 db                	xor    %ebx,%ebx
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (p->state != RUNNABLE || p->q_num != 4)
80103de8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103dec:	75 1a                	jne    80103e08 <fcfs+0x38>
80103dee:	83 b8 e4 00 00 00 04 	cmpl   $0x4,0xe4(%eax)
80103df5:	75 11                	jne    80103e08 <fcfs+0x38>
      if (p->creation_time < mn)
80103df7:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80103dfd:	39 ca                	cmp    %ecx,%edx
80103dff:	73 07                	jae    80103e08 <fcfs+0x38>
        mn = p->creation_time;
80103e01:	89 d1                	mov    %edx,%ecx
80103e03:	89 c3                	mov    %eax,%ebx
80103e05:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e08:	05 0c 01 00 00       	add    $0x10c,%eax
80103e0d:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80103e12:	75 d4                	jne    80103de8 <fcfs+0x18>
}
80103e14:	89 d8                	mov    %ebx,%eax
80103e16:	5b                   	pop    %ebx
80103e17:	5d                   	pop    %ebp
80103e18:	c3                   	ret    
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <bjf>:
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
  float rank_rv = -1;
80103e25:	d9 e8                	fld1   
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e27:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
  float rank_rv = -1;
80103e2c:	d9 e0                	fchs   
{
80103e2e:	89 e5                	mov    %esp,%ebp
80103e30:	53                   	push   %ebx
  struct proc *return_value = NULL_PROC;
80103e31:	31 db                	xor    %ebx,%ebx
{
80103e33:	83 ec 04             	sub    $0x4,%esp
80103e36:	eb 2a                	jmp    80103e62 <bjf+0x42>
80103e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop
    if (rank_rv == -1 || rank_p < rank_rv){
80103e40:	75 6f                	jne    80103eb1 <bjf+0x91>
80103e42:	dd d9                	fstp   %st(1)
80103e44:	eb 0c                	jmp    80103e52 <bjf+0x32>
80103e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
80103e50:	dd d8                	fstp   %st(0)
80103e52:	89 cb                	mov    %ecx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e54:	81 c1 0c 01 00 00    	add    $0x10c,%ecx
80103e5a:	81 f9 54 80 11 80    	cmp    $0x80118054,%ecx
80103e60:	74 6e                	je     80103ed0 <bjf+0xb0>
    if(p->state != RUNNABLE || p->q_num != BJF_QUEUE)
80103e62:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80103e66:	75 ec                	jne    80103e54 <bjf+0x34>
80103e68:	83 b9 e4 00 00 00 03 	cmpl   $0x3,0xe4(%ecx)
80103e6f:	75 e3                	jne    80103e54 <bjf+0x34>
    rank_p = (p->priority_ratio / p->tickets) + (p->arrival_time * p->arrival_time_ratio) + (p->executed_cycles * p->executed_cycles_ratio); 
80103e71:	8b 81 00 01 00 00    	mov    0x100(%ecx),%eax
80103e77:	99                   	cltd   
80103e78:	f7 b9 fc 00 00 00    	idivl  0xfc(%ecx)
80103e7e:	8b 91 f4 00 00 00    	mov    0xf4(%ecx),%edx
80103e84:	0f af 91 04 01 00 00 	imul   0x104(%ecx),%edx
80103e8b:	01 d0                	add    %edx,%eax
80103e8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
80103e90:	db 45 f8             	fildl  -0x8(%ebp)
80103e93:	db 81 08 01 00 00    	fildl  0x108(%ecx)
80103e99:	d8 89 ec 00 00 00    	fmuls  0xec(%ecx)
80103e9f:	de c1                	faddp  %st,%st(1)
    if (rank_rv == -1 || rank_p < rank_rv){
80103ea1:	d9 e8                	fld1   
80103ea3:	d9 e0                	fchs   
80103ea5:	d9 ca                	fxch   %st(2)
80103ea7:	db ea                	fucomi %st(2),%st
80103ea9:	dd da                	fstp   %st(2)
80103eab:	7b 93                	jnp    80103e40 <bjf+0x20>
80103ead:	d9 c9                	fxch   %st(1)
80103eaf:	eb 07                	jmp    80103eb8 <bjf+0x98>
80103eb1:	d9 c9                	fxch   %st(1)
80103eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb7:	90                   	nop
80103eb8:	db f1                	fcomi  %st(1),%st
80103eba:	77 94                	ja     80103e50 <bjf+0x30>
80103ebc:	dd d9                	fstp   %st(1)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebe:	81 c1 0c 01 00 00    	add    $0x10c,%ecx
80103ec4:	81 f9 54 80 11 80    	cmp    $0x80118054,%ecx
80103eca:	75 96                	jne    80103e62 <bjf+0x42>
80103ecc:	dd d8                	fstp   %st(0)
80103ece:	eb 02                	jmp    80103ed2 <bjf+0xb2>
80103ed0:	dd d8                	fstp   %st(0)
}
80103ed2:	83 c4 04             	add    $0x4,%esp
80103ed5:	89 d8                	mov    %ebx,%eax
80103ed7:	5b                   	pop    %ebx
80103ed8:	5d                   	pop    %ebp
80103ed9:	c3                   	ret    
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ee0 <get_next_proc>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	53                   	push   %ebx
80103ee8:	83 ec 04             	sub    $0x4,%esp
  struct proc *p = round_robin();
80103eeb:	e8 70 fe ff ff       	call   80103d60 <round_robin>
80103ef0:	89 c3                	mov    %eax,%ebx
  if (p == NULL_PROC)
80103ef2:	85 c0                	test   %eax,%eax
80103ef4:	74 0a                	je     80103f00 <get_next_proc+0x20>
}
80103ef6:	83 c4 04             	add    $0x4,%esp
80103ef9:	89 d8                	mov    %ebx,%eax
80103efb:	5b                   	pop    %ebx
80103efc:	5d                   	pop    %ebp
80103efd:	c3                   	ret    
80103efe:	66 90                	xchg   %ax,%ax
  int mn = 2e9;
80103f00:	b8 00 94 35 77       	mov    $0x77359400,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f05:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE || p->q_num != 4)
80103f10:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103f14:	75 1a                	jne    80103f30 <get_next_proc+0x50>
80103f16:	83 ba e4 00 00 00 04 	cmpl   $0x4,0xe4(%edx)
80103f1d:	75 11                	jne    80103f30 <get_next_proc+0x50>
      if (p->creation_time < mn)
80103f1f:	8b 8a e0 00 00 00    	mov    0xe0(%edx),%ecx
80103f25:	39 c1                	cmp    %eax,%ecx
80103f27:	73 07                	jae    80103f30 <get_next_proc+0x50>
        mn = p->creation_time;
80103f29:	89 c8                	mov    %ecx,%eax
80103f2b:	89 d3                	mov    %edx,%ebx
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f30:	81 c2 0c 01 00 00    	add    $0x10c,%edx
80103f36:	81 fa 54 80 11 80    	cmp    $0x80118054,%edx
80103f3c:	75 d2                	jne    80103f10 <get_next_proc+0x30>
  if (p == NULL_PROC)
80103f3e:	85 db                	test   %ebx,%ebx
80103f40:	75 b4                	jne    80103ef6 <get_next_proc+0x16>
}
80103f42:	83 c4 04             	add    $0x4,%esp
80103f45:	5b                   	pop    %ebx
80103f46:	5d                   	pop    %ebp
    p = bjf();
80103f47:	e9 d4 fe ff ff       	jmp    80103e20 <bjf>
80103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f50 <update_waited_cycles>:
{
80103f50:	f3 0f 1e fb          	endbr32 
80103f54:	55                   	push   %ebp
      p->waited_cycles += cycles;
80103f55:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f57:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
80103f5c:	89 e5                	mov    %esp,%ebp
80103f5e:	83 ec 08             	sub    $0x8,%esp
      p->waited_cycles += cycles;
80103f61:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80103f67:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state == RUNNABLE)
80103f70:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f74:	75 0f                	jne    80103f85 <update_waited_cycles+0x35>
      p->waited_cycles += cycles;
80103f76:	df 6d f8             	fildll -0x8(%ebp)
80103f79:	d8 80 e8 00 00 00    	fadds  0xe8(%eax)
80103f7f:	d9 98 e8 00 00 00    	fstps  0xe8(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f85:	05 0c 01 00 00       	add    $0x10c,%eax
80103f8a:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80103f8f:	75 df                	jne    80103f70 <update_waited_cycles+0x20>
  executing_proc->waited_cycles = 0;
80103f91:	8b 45 08             	mov    0x8(%ebp),%eax
80103f94:	c7 80 e8 00 00 00 00 	movl   $0x0,0xe8(%eax)
80103f9b:	00 00 00 
}
80103f9e:	c9                   	leave  
80103f9f:	c3                   	ret    

80103fa0 <scheduler>:
{
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	57                   	push   %edi
80103fa8:	56                   	push   %esi
80103fa9:	53                   	push   %ebx
80103faa:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103fad:	e8 9e f9 ff ff       	call   80103950 <mycpu>
  c->proc = 0;
80103fb2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fb9:	00 00 00 
  struct cpu *c = mycpu();
80103fbc:	89 c3                	mov    %eax,%ebx
  ptable.prev_proc = ptable.proc;
80103fbe:	8d 40 04             	lea    0x4(%eax),%eax
80103fc1:	c7 05 54 80 11 80 54 	movl   $0x80113d54,0x80118054
80103fc8:	3d 11 80 
80103fcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103fce:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80103fd0:	fb                   	sti    
    acquire(&ptable.lock);
80103fd1:	83 ec 0c             	sub    $0xc,%esp
80103fd4:	68 20 3d 11 80       	push   $0x80113d20
80103fd9:	e8 b2 14 00 00       	call   80105490 <acquire>
    t1 = ticks;
80103fde:	8b 3d a0 88 11 80    	mov    0x801188a0,%edi
    p = get_next_proc();
80103fe4:	e8 f7 fe ff ff       	call   80103ee0 <get_next_proc>
    if (p != NULL_PROC) 
80103fe9:	83 c4 10             	add    $0x10,%esp
    p = get_next_proc();
80103fec:	89 c6                	mov    %eax,%esi
    if (p != NULL_PROC) 
80103fee:	85 c0                	test   %eax,%eax
80103ff0:	0f 84 91 00 00 00    	je     80104087 <scheduler+0xe7>
      get_old();
80103ff6:	e8 e5 fc ff ff       	call   80103ce0 <get_old>
      p->executed_cycles += 0.1;
80103ffb:	dd 05 c8 8a 10 80    	fldl   0x80108ac8
      switchuvm(p);
80104001:	83 ec 0c             	sub    $0xc,%esp
      p->executed_cycles += 0.1;
80104004:	d8 86 ec 00 00 00    	fadds  0xec(%esi)
8010400a:	d9 9e ec 00 00 00    	fstps  0xec(%esi)
      c->proc = p;
80104010:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
      switchuvm(p);
80104016:	56                   	push   %esi
80104017:	e8 94 3b 00 00       	call   80107bb0 <switchuvm>
      p->state = RUNNING;
8010401c:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), p->context);
80104023:	58                   	pop    %eax
80104024:	5a                   	pop    %edx
80104025:	ff 76 1c             	pushl  0x1c(%esi)
80104028:	ff 75 dc             	pushl  -0x24(%ebp)
8010402b:	e8 93 17 00 00       	call   801057c3 <swtch>
      switchkvm();
80104030:	e8 5b 3b 00 00       	call   80107b90 <switchkvm>
      update_waited_cycles(p, t2 - t1);
80104035:	8b 0d a0 88 11 80    	mov    0x801188a0,%ecx
8010403b:	83 c4 10             	add    $0x10,%esp
      p->waited_cycles += cycles;
8010403e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104045:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
      update_waited_cycles(p, t2 - t1);
8010404a:	29 f9                	sub    %edi,%ecx
      p->waited_cycles += cycles;
8010404c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010404f:	90                   	nop
    if (p->state == RUNNABLE)
80104050:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104054:	75 0f                	jne    80104065 <scheduler+0xc5>
      p->waited_cycles += cycles;
80104056:	df 6d e0             	fildll -0x20(%ebp)
80104059:	d8 82 e8 00 00 00    	fadds  0xe8(%edx)
8010405f:	d9 9a e8 00 00 00    	fstps  0xe8(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104065:	81 c2 0c 01 00 00    	add    $0x10c,%edx
8010406b:	81 fa 54 80 11 80    	cmp    $0x80118054,%edx
80104071:	75 dd                	jne    80104050 <scheduler+0xb0>
  executing_proc->waited_cycles = 0;
80104073:	c7 86 e8 00 00 00 00 	movl   $0x0,0xe8(%esi)
8010407a:	00 00 00 
      c->proc = 0;
8010407d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104084:	00 00 00 
    release(&ptable.lock);
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 20 3d 11 80       	push   $0x80113d20
8010408f:	e8 bc 14 00 00       	call   80105550 <release>
    sti();
80104094:	83 c4 10             	add    $0x10,%esp
80104097:	e9 34 ff ff ff       	jmp    80103fd0 <scheduler+0x30>
8010409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040a0 <sched>:
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	56                   	push   %esi
801040a8:	53                   	push   %ebx
  pushcli();
801040a9:	e8 e2 12 00 00       	call   80105390 <pushcli>
  c = mycpu();
801040ae:	e8 9d f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801040b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b9:	e8 22 13 00 00       	call   801053e0 <popcli>
  if(!holding(&ptable.lock))
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	68 20 3d 11 80       	push   $0x80113d20
801040c6:	e8 75 13 00 00       	call   80105440 <holding>
801040cb:	83 c4 10             	add    $0x10,%esp
801040ce:	85 c0                	test   %eax,%eax
801040d0:	74 4f                	je     80104121 <sched+0x81>
  if(mycpu()->ncli != 1)
801040d2:	e8 79 f8 ff ff       	call   80103950 <mycpu>
801040d7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040de:	75 68                	jne    80104148 <sched+0xa8>
  if(p->state == RUNNING)
801040e0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040e4:	74 55                	je     8010413b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040e6:	9c                   	pushf  
801040e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040e8:	f6 c4 02             	test   $0x2,%ah
801040eb:	75 41                	jne    8010412e <sched+0x8e>
  intena = mycpu()->intena;
801040ed:	e8 5e f8 ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040f2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801040f5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040fb:	e8 50 f8 ff ff       	call   80103950 <mycpu>
80104100:	83 ec 08             	sub    $0x8,%esp
80104103:	ff 70 04             	pushl  0x4(%eax)
80104106:	53                   	push   %ebx
80104107:	e8 b7 16 00 00       	call   801057c3 <swtch>
  mycpu()->intena = intena;
8010410c:	e8 3f f8 ff ff       	call   80103950 <mycpu>
}
80104111:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104114:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010411a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010411d:	5b                   	pop    %ebx
8010411e:	5e                   	pop    %esi
8010411f:	5d                   	pop    %ebp
80104120:	c3                   	ret    
    panic("sched ptable.lock");
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	68 fb 87 10 80       	push   $0x801087fb
80104129:	e8 62 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010412e:	83 ec 0c             	sub    $0xc,%esp
80104131:	68 27 88 10 80       	push   $0x80108827
80104136:	e8 55 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
8010413b:	83 ec 0c             	sub    $0xc,%esp
8010413e:	68 19 88 10 80       	push   $0x80108819
80104143:	e8 48 c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	68 0d 88 10 80       	push   $0x8010880d
80104150:	e8 3b c2 ff ff       	call   80100390 <panic>
80104155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <exit>:
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	57                   	push   %edi
80104168:	56                   	push   %esi
80104169:	53                   	push   %ebx
8010416a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010416d:	e8 1e 12 00 00       	call   80105390 <pushcli>
  c = mycpu();
80104172:	e8 d9 f7 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104177:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010417d:	e8 5e 12 00 00       	call   801053e0 <popcli>
  if(curproc == initproc)
80104182:	8d 5e 28             	lea    0x28(%esi),%ebx
80104185:	8d 7e 68             	lea    0x68(%esi),%edi
80104188:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010418e:	0f 84 fd 00 00 00    	je     80104291 <exit+0x131>
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104198:	8b 03                	mov    (%ebx),%eax
8010419a:	85 c0                	test   %eax,%eax
8010419c:	74 12                	je     801041b0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010419e:	83 ec 0c             	sub    $0xc,%esp
801041a1:	50                   	push   %eax
801041a2:	e8 29 cd ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
801041a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801041b0:	83 c3 04             	add    $0x4,%ebx
801041b3:	39 df                	cmp    %ebx,%edi
801041b5:	75 e1                	jne    80104198 <exit+0x38>
  begin_op();
801041b7:	e8 84 eb ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
801041bc:	83 ec 0c             	sub    $0xc,%esp
801041bf:	ff 76 68             	pushl  0x68(%esi)
801041c2:	e8 d9 d6 ff ff       	call   801018a0 <iput>
  end_op();
801041c7:	e8 e4 eb ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
801041cc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801041d3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041da:	e8 b1 12 00 00       	call   80105490 <acquire>
  wakeup1(curproc->parent);
801041df:	8b 56 14             	mov    0x14(%esi),%edx
801041e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041ea:	eb 10                	jmp    801041fc <exit+0x9c>
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f0:	05 0c 01 00 00       	add    $0x10c,%eax
801041f5:	3d 54 80 11 80       	cmp    $0x80118054,%eax
801041fa:	74 1e                	je     8010421a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801041fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104200:	75 ee                	jne    801041f0 <exit+0x90>
80104202:	3b 50 20             	cmp    0x20(%eax),%edx
80104205:	75 e9                	jne    801041f0 <exit+0x90>
      p->state = RUNNABLE;
80104207:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010420e:	05 0c 01 00 00       	add    $0x10c,%eax
80104213:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104218:	75 e2                	jne    801041fc <exit+0x9c>
      p->parent = initproc;
8010421a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104220:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104225:	eb 17                	jmp    8010423e <exit+0xde>
80104227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422e:	66 90                	xchg   %ax,%ax
80104230:	81 c2 0c 01 00 00    	add    $0x10c,%edx
80104236:	81 fa 54 80 11 80    	cmp    $0x80118054,%edx
8010423c:	74 3a                	je     80104278 <exit+0x118>
    if(p->parent == curproc){
8010423e:	39 72 14             	cmp    %esi,0x14(%edx)
80104241:	75 ed                	jne    80104230 <exit+0xd0>
      if(p->state == ZOMBIE)
80104243:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104247:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010424a:	75 e4                	jne    80104230 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010424c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104251:	eb 11                	jmp    80104264 <exit+0x104>
80104253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104257:	90                   	nop
80104258:	05 0c 01 00 00       	add    $0x10c,%eax
8010425d:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104262:	74 cc                	je     80104230 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104264:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104268:	75 ee                	jne    80104258 <exit+0xf8>
8010426a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010426d:	75 e9                	jne    80104258 <exit+0xf8>
      p->state = RUNNABLE;
8010426f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104276:	eb e0                	jmp    80104258 <exit+0xf8>
  curproc->state = ZOMBIE;
80104278:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010427f:	e8 1c fe ff ff       	call   801040a0 <sched>
  panic("zombie exit");
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	68 48 88 10 80       	push   $0x80108848
8010428c:	e8 ff c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104291:	83 ec 0c             	sub    $0xc,%esp
80104294:	68 3b 88 10 80       	push   $0x8010883b
80104299:	e8 f2 c0 ff ff       	call   80100390 <panic>
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <yield>:
{
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	53                   	push   %ebx
801042a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042ab:	68 20 3d 11 80       	push   $0x80113d20
801042b0:	e8 db 11 00 00       	call   80105490 <acquire>
  pushcli();
801042b5:	e8 d6 10 00 00       	call   80105390 <pushcli>
  c = mycpu();
801042ba:	e8 91 f6 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801042bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c5:	e8 16 11 00 00       	call   801053e0 <popcli>
  myproc()->state = RUNNABLE;
801042ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042d1:	e8 ca fd ff ff       	call   801040a0 <sched>
  release(&ptable.lock);
801042d6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042dd:	e8 6e 12 00 00       	call   80105550 <release>
}
801042e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	c9                   	leave  
801042e9:	c3                   	ret    
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <sleep>:
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	57                   	push   %edi
801042f8:	56                   	push   %esi
801042f9:	53                   	push   %ebx
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104300:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104303:	e8 88 10 00 00       	call   80105390 <pushcli>
  c = mycpu();
80104308:	e8 43 f6 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010430d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104313:	e8 c8 10 00 00       	call   801053e0 <popcli>
  if(p == 0)
80104318:	85 db                	test   %ebx,%ebx
8010431a:	0f 84 83 00 00 00    	je     801043a3 <sleep+0xb3>
  if(lk == 0)
80104320:	85 f6                	test   %esi,%esi
80104322:	74 72                	je     80104396 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104324:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010432a:	74 4c                	je     80104378 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010432c:	83 ec 0c             	sub    $0xc,%esp
8010432f:	68 20 3d 11 80       	push   $0x80113d20
80104334:	e8 57 11 00 00       	call   80105490 <acquire>
    release(lk);
80104339:	89 34 24             	mov    %esi,(%esp)
8010433c:	e8 0f 12 00 00       	call   80105550 <release>
  p->chan = chan;
80104341:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104344:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010434b:	e8 50 fd ff ff       	call   801040a0 <sched>
  p->chan = 0;
80104350:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104357:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010435e:	e8 ed 11 00 00       	call   80105550 <release>
    acquire(lk);
80104363:	89 75 08             	mov    %esi,0x8(%ebp)
80104366:	83 c4 10             	add    $0x10,%esp
}
80104369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010436c:	5b                   	pop    %ebx
8010436d:	5e                   	pop    %esi
8010436e:	5f                   	pop    %edi
8010436f:	5d                   	pop    %ebp
    acquire(lk);
80104370:	e9 1b 11 00 00       	jmp    80105490 <acquire>
80104375:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104378:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010437b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104382:	e8 19 fd ff ff       	call   801040a0 <sched>
  p->chan = 0;
80104387:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010438e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104391:	5b                   	pop    %ebx
80104392:	5e                   	pop    %esi
80104393:	5f                   	pop    %edi
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret    
    panic("sleep without lk");
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	68 5a 88 10 80       	push   $0x8010885a
8010439e:	e8 ed bf ff ff       	call   80100390 <panic>
    panic("sleep");
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 54 88 10 80       	push   $0x80108854
801043ab:	e8 e0 bf ff ff       	call   80100390 <panic>

801043b0 <wait>:
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	56                   	push   %esi
801043b8:	53                   	push   %ebx
  pushcli();
801043b9:	e8 d2 0f 00 00       	call   80105390 <pushcli>
  c = mycpu();
801043be:	e8 8d f5 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801043c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043c9:	e8 12 10 00 00       	call   801053e0 <popcli>
  acquire(&ptable.lock);
801043ce:	83 ec 0c             	sub    $0xc,%esp
801043d1:	68 20 3d 11 80       	push   $0x80113d20
801043d6:	e8 b5 10 00 00       	call   80105490 <acquire>
801043db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043de:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801043e5:	eb 17                	jmp    801043fe <wait+0x4e>
801043e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ee:	66 90                	xchg   %ax,%ax
801043f0:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
801043f6:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
801043fc:	74 1e                	je     8010441c <wait+0x6c>
      if(p->parent != curproc)
801043fe:	39 73 14             	cmp    %esi,0x14(%ebx)
80104401:	75 ed                	jne    801043f0 <wait+0x40>
      if(p->state == ZOMBIE){
80104403:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104407:	74 37                	je     80104440 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104409:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
      havekids = 1;
8010440f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104414:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
8010441a:	75 e2                	jne    801043fe <wait+0x4e>
    if(!havekids || curproc->killed){
8010441c:	85 c0                	test   %eax,%eax
8010441e:	74 76                	je     80104496 <wait+0xe6>
80104420:	8b 46 24             	mov    0x24(%esi),%eax
80104423:	85 c0                	test   %eax,%eax
80104425:	75 6f                	jne    80104496 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104427:	83 ec 08             	sub    $0x8,%esp
8010442a:	68 20 3d 11 80       	push   $0x80113d20
8010442f:	56                   	push   %esi
80104430:	e8 bb fe ff ff       	call   801042f0 <sleep>
    havekids = 0;
80104435:	83 c4 10             	add    $0x10,%esp
80104438:	eb a4                	jmp    801043de <wait+0x2e>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104446:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104449:	e8 32 e0 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
8010444e:	5a                   	pop    %edx
8010444f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104452:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104459:	e8 12 3b 00 00       	call   80107f70 <freevm>
        release(&ptable.lock);
8010445e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104465:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010446c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104473:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104477:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010447e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104485:	e8 c6 10 00 00       	call   80105550 <release>
        return pid;
8010448a:	83 c4 10             	add    $0x10,%esp
}
8010448d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104490:	89 f0                	mov    %esi,%eax
80104492:	5b                   	pop    %ebx
80104493:	5e                   	pop    %esi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret    
      release(&ptable.lock);
80104496:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104499:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010449e:	68 20 3d 11 80       	push   $0x80113d20
801044a3:	e8 a8 10 00 00       	call   80105550 <release>
      return -1;
801044a8:	83 c4 10             	add    $0x10,%esp
801044ab:	eb e0                	jmp    8010448d <wait+0xdd>
801044ad:	8d 76 00             	lea    0x0(%esi),%esi

801044b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	53                   	push   %ebx
801044b8:	83 ec 10             	sub    $0x10,%esp
801044bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044be:	68 20 3d 11 80       	push   $0x80113d20
801044c3:	e8 c8 0f 00 00       	call   80105490 <acquire>
801044c8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044cb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044d0:	eb 12                	jmp    801044e4 <wakeup+0x34>
801044d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d8:	05 0c 01 00 00       	add    $0x10c,%eax
801044dd:	3d 54 80 11 80       	cmp    $0x80118054,%eax
801044e2:	74 1e                	je     80104502 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801044e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044e8:	75 ee                	jne    801044d8 <wakeup+0x28>
801044ea:	3b 58 20             	cmp    0x20(%eax),%ebx
801044ed:	75 e9                	jne    801044d8 <wakeup+0x28>
      p->state = RUNNABLE;
801044ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f6:	05 0c 01 00 00       	add    $0x10c,%eax
801044fb:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104500:	75 e2                	jne    801044e4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104502:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104509:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450c:	c9                   	leave  
  release(&ptable.lock);
8010450d:	e9 3e 10 00 00       	jmp    80105550 <release>
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	53                   	push   %ebx
80104528:	83 ec 10             	sub    $0x10,%esp
8010452b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010452e:	68 20 3d 11 80       	push   $0x80113d20
80104533:	e8 58 0f 00 00       	call   80105490 <acquire>
80104538:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104540:	eb 12                	jmp    80104554 <kill+0x34>
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104548:	05 0c 01 00 00       	add    $0x10c,%eax
8010454d:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104552:	74 34                	je     80104588 <kill+0x68>
    if(p->pid == pid){
80104554:	39 58 10             	cmp    %ebx,0x10(%eax)
80104557:	75 ef                	jne    80104548 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104559:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010455d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104564:	75 07                	jne    8010456d <kill+0x4d>
        p->state = RUNNABLE;
80104566:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010456d:	83 ec 0c             	sub    $0xc,%esp
80104570:	68 20 3d 11 80       	push   $0x80113d20
80104575:	e8 d6 0f 00 00       	call   80105550 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010457a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010457d:	83 c4 10             	add    $0x10,%esp
80104580:	31 c0                	xor    %eax,%eax
}
80104582:	c9                   	leave  
80104583:	c3                   	ret    
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 20 3d 11 80       	push   $0x80113d20
80104590:	e8 bb 0f 00 00       	call   80105550 <release>
}
80104595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104598:	83 c4 10             	add    $0x10,%esp
8010459b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045a0:	c9                   	leave  
801045a1:	c3                   	ret    
801045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	57                   	push   %edi
801045b8:	56                   	push   %esi
801045b9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801045bc:	53                   	push   %ebx
801045bd:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801045c2:	83 ec 3c             	sub    $0x3c,%esp
801045c5:	eb 2b                	jmp    801045f2 <procdump+0x42>
801045c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ce:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	68 b6 88 10 80       	push   $0x801088b6
801045d8:	e8 d3 c0 ff ff       	call   801006b0 <cprintf>
801045dd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e0:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
801045e6:	81 fb c0 80 11 80    	cmp    $0x801180c0,%ebx
801045ec:	0f 84 8e 00 00 00    	je     80104680 <procdump+0xd0>
    if(p->state == UNUSED)
801045f2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045f5:	85 c0                	test   %eax,%eax
801045f7:	74 e7                	je     801045e0 <procdump+0x30>
      state = "???";
801045f9:	ba 6b 88 10 80       	mov    $0x8010886b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045fe:	83 f8 05             	cmp    $0x5,%eax
80104601:	77 11                	ja     80104614 <procdump+0x64>
80104603:	8b 14 85 a8 8a 10 80 	mov    -0x7fef7558(,%eax,4),%edx
      state = "???";
8010460a:	b8 6b 88 10 80       	mov    $0x8010886b,%eax
8010460f:	85 d2                	test   %edx,%edx
80104611:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104614:	53                   	push   %ebx
80104615:	52                   	push   %edx
80104616:	ff 73 a4             	pushl  -0x5c(%ebx)
80104619:	68 6f 88 10 80       	push   $0x8010886f
8010461e:	e8 8d c0 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104623:	83 c4 10             	add    $0x10,%esp
80104626:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010462a:	75 a4                	jne    801045d0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010462c:	83 ec 08             	sub    $0x8,%esp
8010462f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104632:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104635:	50                   	push   %eax
80104636:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104639:	8b 40 0c             	mov    0xc(%eax),%eax
8010463c:	83 c0 08             	add    $0x8,%eax
8010463f:	50                   	push   %eax
80104640:	e8 eb 0c 00 00       	call   80105330 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104645:	83 c4 10             	add    $0x10,%esp
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop
80104650:	8b 17                	mov    (%edi),%edx
80104652:	85 d2                	test   %edx,%edx
80104654:	0f 84 76 ff ff ff    	je     801045d0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010465a:	83 ec 08             	sub    $0x8,%esp
8010465d:	83 c7 04             	add    $0x4,%edi
80104660:	52                   	push   %edx
80104661:	68 c1 82 10 80       	push   $0x801082c1
80104666:	e8 45 c0 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010466b:	83 c4 10             	add    $0x10,%esp
8010466e:	39 fe                	cmp    %edi,%esi
80104670:	75 de                	jne    80104650 <procdump+0xa0>
80104672:	e9 59 ff ff ff       	jmp    801045d0 <procdump+0x20>
80104677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467e:	66 90                	xchg   %ax,%ax
  }
}
80104680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104683:	5b                   	pop    %ebx
80104684:	5e                   	pop    %esi
80104685:	5f                   	pop    %edi
80104686:	5d                   	pop    %ebp
80104687:	c3                   	ret    
80104688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <set_tickets>:

void
set_tickets(int pid, int tickets)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104695:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010469a:	89 e5                	mov    %esp,%ebp
8010469c:	8b 55 08             	mov    0x8(%ebp),%edx
8010469f:	eb 13                	jmp    801046b4 <set_tickets+0x24>
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a8:	05 0c 01 00 00       	add    $0x10c,%eax
801046ad:	3d 54 80 11 80       	cmp    $0x80118054,%eax
801046b2:	74 0e                	je     801046c2 <set_tickets+0x32>
    if (p->pid == pid){
801046b4:	39 50 10             	cmp    %edx,0x10(%eax)
801046b7:	75 ef                	jne    801046a8 <set_tickets+0x18>
      p->tickets = tickets;
801046b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801046bc:	89 90 fc 00 00 00    	mov    %edx,0xfc(%eax)
      return;
    }
  }
}
801046c2:	5d                   	pop    %ebp
801046c3:	c3                   	ret    
801046c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046cf:	90                   	nop

801046d0 <set_proc_queue>:

void
set_proc_queue(int pid, int q_num)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
801046da:	89 e5                	mov    %esp,%ebp
801046dc:	8b 55 08             	mov    0x8(%ebp),%edx
801046df:	eb 13                	jmp    801046f4 <set_proc_queue+0x24>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e8:	05 0c 01 00 00       	add    $0x10c,%eax
801046ed:	3d 54 80 11 80       	cmp    $0x80118054,%eax
801046f2:	74 0e                	je     80104702 <set_proc_queue+0x32>
    if (p->pid == pid){
801046f4:	39 50 10             	cmp    %edx,0x10(%eax)
801046f7:	75 ef                	jne    801046e8 <set_proc_queue+0x18>
      p->q_num = q_num;
801046f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801046fc:	89 90 e4 00 00 00    	mov    %edx,0xe4(%eax)
      return;
    }
  }
}
80104702:	5d                   	pop    %ebp
80104703:	c3                   	ret    
80104704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <set_bjf_params_in_proc>:

void
set_bjf_params_in_proc(int pid, int pratio, int atratio, int excratio)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104715:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010471a:	89 e5                	mov    %esp,%ebp
8010471c:	8b 55 08             	mov    0x8(%ebp),%edx
8010471f:	eb 13                	jmp    80104734 <set_bjf_params_in_proc+0x24>
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104728:	05 0c 01 00 00       	add    $0x10c,%eax
8010472d:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104732:	74 20                	je     80104754 <set_bjf_params_in_proc+0x44>
    if (p->pid == pid){
80104734:	39 50 10             	cmp    %edx,0x10(%eax)
80104737:	75 ef                	jne    80104728 <set_bjf_params_in_proc+0x18>
      p->priority_ratio = pratio;
80104739:	8b 55 0c             	mov    0xc(%ebp),%edx
8010473c:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
      p->arrival_time_ratio = atratio;
80104742:	8b 55 10             	mov    0x10(%ebp),%edx
80104745:	89 90 04 01 00 00    	mov    %edx,0x104(%eax)
      p->executed_cycles_ratio = excratio;
8010474b:	8b 55 14             	mov    0x14(%ebp),%edx
8010474e:	89 90 08 01 00 00    	mov    %edx,0x108(%eax)
      return;
    }
  }
}
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi

80104760 <set_bjf_params_in_system>:

void
set_bjf_params_in_system(int pratio, int atratio, int excratio)
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104765:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010476a:	89 e5                	mov    %esp,%ebp
8010476c:	53                   	push   %ebx
8010476d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104770:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104773:	8b 55 10             	mov    0x10(%ebp),%edx
80104776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
    p->priority_ratio = pratio;
80104780:	89 98 00 01 00 00    	mov    %ebx,0x100(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104786:	05 0c 01 00 00       	add    $0x10c,%eax
    p->arrival_time_ratio = atratio;
8010478b:	89 48 f8             	mov    %ecx,-0x8(%eax)
    p->executed_cycles_ratio = excratio;
8010478e:	89 50 fc             	mov    %edx,-0x4(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104791:	3d 54 80 11 80       	cmp    $0x80118054,%eax
80104796:	75 e8                	jne    80104780 <set_bjf_params_in_system+0x20>
  }
  return;
}
80104798:	5b                   	pop    %ebx
80104799:	5d                   	pop    %ebp
8010479a:	c3                   	ret    
8010479b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <adjust_columns>:

// print
void adjust_columns(int space_ahead)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	56                   	push   %esi
801047a8:	8b 75 08             	mov    0x8(%ebp),%esi
801047ab:	53                   	push   %ebx
  for (int i = 0; i < space_ahead; i++)
801047ac:	85 f6                	test   %esi,%esi
801047ae:	7e 1f                	jle    801047cf <adjust_columns+0x2f>
801047b0:	31 db                	xor    %ebx,%ebx
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
801047b8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
801047bb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
801047be:	68 4b 89 10 80       	push   $0x8010894b
801047c3:	e8 e8 be ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
801047c8:	83 c4 10             	add    $0x10,%esp
801047cb:	39 de                	cmp    %ebx,%esi
801047cd:	75 e9                	jne    801047b8 <adjust_columns+0x18>
  return;
}
801047cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <count_digits>:

int
count_digits(int number)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047eb:	53                   	push   %ebx
801047ec:	bb 01 00 00 00       	mov    $0x1,%ebx
  int digits = 0;
  if (number == 0)
801047f1:	85 c9                	test   %ecx,%ecx
801047f3:	74 1e                	je     80104813 <count_digits+0x33>
  int digits = 0;
801047f5:	31 db                	xor    %ebx,%ebx
  }
  else
  {
    while(number != 0)
    {
      number /= 10;
801047f7:	be 67 66 66 66       	mov    $0x66666667,%esi
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104800:	89 c8                	mov    %ecx,%eax
80104802:	c1 f9 1f             	sar    $0x1f,%ecx
      digits++;
80104805:	83 c3 01             	add    $0x1,%ebx
      number /= 10;
80104808:	f7 ee                	imul   %esi
8010480a:	c1 fa 02             	sar    $0x2,%edx
    while(number != 0)
8010480d:	29 ca                	sub    %ecx,%edx
8010480f:	89 d1                	mov    %edx,%ecx
80104811:	75 ed                	jne    80104800 <count_digits+0x20>
    }
  }
  return digits;
}
80104813:	89 d8                	mov    %ebx,%eax
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5d                   	pop    %ebp
80104818:	c3                   	ret    
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104820 <reverse_string>:

void reverse_string(char* str, int strlen) 
{ 
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	56                   	push   %esi
    int start = 0, end = strlen - 1, temp; 
80104828:	8b 45 0c             	mov    0xc(%ebp),%eax
{ 
8010482b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010482e:	53                   	push   %ebx
    int start = 0, end = strlen - 1, temp; 
8010482f:	83 e8 01             	sub    $0x1,%eax
    while (start < end) { 
80104832:	85 c0                	test   %eax,%eax
80104834:	7e 24                	jle    8010485a <reverse_string+0x3a>
    int start = 0, end = strlen - 1, temp; 
80104836:	31 d2                	xor    %edx,%edx
80104838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop
        temp = str[start]; 
80104840:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        str[start] = str[end]; 
80104844:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
80104848:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        str[end] = temp; 
8010484b:	89 f3                	mov    %esi,%ebx
        start++; 
8010484d:	83 c2 01             	add    $0x1,%edx
        str[end] = temp; 
80104850:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
        end--; 
80104853:	83 e8 01             	sub    $0x1,%eax
    while (start < end) { 
80104856:	39 c2                	cmp    %eax,%edx
80104858:	7c e6                	jl     80104840 <reverse_string+0x20>
    } 
} 
8010485a:	5b                   	pop    %ebx
8010485b:	5e                   	pop    %esi
8010485c:	5d                   	pop    %ebp
8010485d:	c3                   	ret    
8010485e:	66 90                	xchg   %ax,%ax

80104860 <itoa>:


int itoa(int num, char snum[], int base) 
{ 
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	56                   	push   %esi
80104869:	53                   	push   %ebx
8010486a:	83 ec 04             	sub    $0x4,%esp
8010486d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104870:	8b 75 0c             	mov    0xc(%ebp),%esi
    int i = 0; 

    if(num == 0)
80104873:	85 c9                	test   %ecx,%ecx
80104875:	0f 85 85 00 00 00    	jne    80104900 <itoa+0xa0>
    while (num) { 
        snum[i++] = (num % 10) + '0'; 
        num = num / 10; 
    } 
  
    while (i < base) 
8010487b:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
      snum[i++] = '0';
8010487f:	c6 06 30             	movb   $0x30,(%esi)
80104882:	bf 01 00 00 00       	mov    $0x1,%edi
    while (i < base) 
80104887:	0f 8e bb 00 00 00    	jle    80104948 <itoa+0xe8>
      snum[i++] = '0';
8010488d:	8b 55 10             	mov    0x10(%ebp),%edx
80104890:	89 f8                	mov    %edi,%eax
80104892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        snum[i++] = '0'; 
80104898:	83 c0 01             	add    $0x1,%eax
8010489b:	c6 44 06 ff 30       	movb   $0x30,-0x1(%esi,%eax,1)
    while (i < base) 
801048a0:	39 c2                	cmp    %eax,%edx
801048a2:	7f f4                	jg     80104898 <itoa+0x38>
801048a4:	8b 45 10             	mov    0x10(%ebp),%eax
801048a7:	8d 58 ff             	lea    -0x1(%eax),%ebx
801048aa:	29 fb                	sub    %edi,%ebx
801048ac:	39 c7                	cmp    %eax,%edi
801048ae:	b8 00 00 00 00       	mov    $0x0,%eax
801048b3:	0f 4d d8             	cmovge %eax,%ebx
801048b6:	8d 54 1f 01          	lea    0x1(%edi,%ebx,1),%edx
801048ba:	01 fb                	add    %edi,%ebx
801048bc:	8d 04 16             	lea    (%esi,%edx,1),%eax
801048bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (start < end) { 
801048c2:	85 db                	test   %ebx,%ebx
801048c4:	7e 24                	jle    801048ea <itoa+0x8a>
    int start = 0, end = strlen - 1, temp; 
801048c6:	31 c0                	xor    %eax,%eax
801048c8:	89 d7                	mov    %edx,%edi
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        temp = str[start]; 
801048d0:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
        str[start] = str[end]; 
801048d4:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
801048d8:	88 0c 06             	mov    %cl,(%esi,%eax,1)
        start++; 
801048db:	83 c0 01             	add    $0x1,%eax
        str[end] = temp; 
801048de:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
        end--; 
801048e1:	83 eb 01             	sub    $0x1,%ebx
    while (start < end) { 
801048e4:	39 d8                	cmp    %ebx,%eax
801048e6:	7c e8                	jl     801048d0 <itoa+0x70>
801048e8:	89 fa                	mov    %edi,%edx
  
    reverse_string(snum, i); 
    snum[i] = '\0'; 
801048ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048ed:	c6 00 00             	movb   $0x0,(%eax)
    return i; 
} 
801048f0:	83 c4 04             	add    $0x4,%esp
801048f3:	89 d0                	mov    %edx,%eax
801048f5:	5b                   	pop    %ebx
801048f6:	5e                   	pop    %esi
801048f7:	5f                   	pop    %edi
801048f8:	5d                   	pop    %ebp
801048f9:	c3                   	ret    
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int i = 0; 
80104900:	31 ff                	xor    %edi,%edi
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        snum[i++] = (num % 10) + '0'; 
80104908:	b8 67 66 66 66       	mov    $0x66666667,%eax
8010490d:	89 fb                	mov    %edi,%ebx
8010490f:	8d 7f 01             	lea    0x1(%edi),%edi
80104912:	f7 e9                	imul   %ecx
80104914:	89 c8                	mov    %ecx,%eax
80104916:	c1 f8 1f             	sar    $0x1f,%eax
80104919:	c1 fa 02             	sar    $0x2,%edx
8010491c:	29 c2                	sub    %eax,%edx
8010491e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104921:	01 c0                	add    %eax,%eax
80104923:	29 c1                	sub    %eax,%ecx
80104925:	83 c1 30             	add    $0x30,%ecx
80104928:	88 4c 3e ff          	mov    %cl,-0x1(%esi,%edi,1)
        num = num / 10; 
8010492c:	89 d1                	mov    %edx,%ecx
    while (num) { 
8010492e:	85 d2                	test   %edx,%edx
80104930:	75 d6                	jne    80104908 <itoa+0xa8>
    while (i < base) 
80104932:	39 7d 10             	cmp    %edi,0x10(%ebp)
80104935:	0f 8f 52 ff ff ff    	jg     8010488d <itoa+0x2d>
8010493b:	8d 04 3e             	lea    (%esi,%edi,1),%eax
8010493e:	89 fa                	mov    %edi,%edx
80104940:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104943:	e9 7a ff ff ff       	jmp    801048c2 <itoa+0x62>
80104948:	8d 46 01             	lea    0x1(%esi),%eax
      snum[i++] = '0';
8010494b:	ba 01 00 00 00       	mov    $0x1,%edx
80104950:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104953:	eb 95                	jmp    801048ea <itoa+0x8a>
80104955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <pow>:

int pow(int x, unsigned int y) 
{ 
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	57                   	push   %edi
80104968:	56                   	push   %esi
    if (y == 0) 
80104969:	be 01 00 00 00       	mov    $0x1,%esi
{ 
8010496e:	53                   	push   %ebx
8010496f:	83 ec 0c             	sub    $0xc,%esp
80104972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104975:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (y == 0) 
80104978:	85 db                	test   %ebx,%ebx
8010497a:	74 1f                	je     8010499b <pow+0x3b>
        return 1; 
    else if (y % 2 == 0) 
8010497c:	89 d8                	mov    %ebx,%eax
8010497e:	d1 eb                	shr    %ebx
80104980:	83 e0 01             	and    $0x1,%eax
80104983:	85 c0                	test   %eax,%eax
80104985:	75 21                	jne    801049a8 <pow+0x48>
        return pow(x, y / 2) * pow(x, y / 2); 
80104987:	83 ec 08             	sub    $0x8,%esp
8010498a:	53                   	push   %ebx
8010498b:	57                   	push   %edi
8010498c:	e8 cf ff ff ff       	call   80104960 <pow>
80104991:	83 c4 10             	add    $0x10,%esp
80104994:	0f af f0             	imul   %eax,%esi
    if (y == 0) 
80104997:	85 db                	test   %ebx,%ebx
80104999:	75 e1                	jne    8010497c <pow+0x1c>
    else
        return x * pow(x, y / 2) * pow(x, y / 2); 
} 
8010499b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010499e:	89 f0                	mov    %esi,%eax
801049a0:	5b                   	pop    %ebx
801049a1:	5e                   	pop    %esi
801049a2:	5f                   	pop    %edi
801049a3:	5d                   	pop    %ebp
801049a4:	c3                   	ret    
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
        return x * pow(x, y / 2) * pow(x, y / 2); 
801049a8:	83 ec 08             	sub    $0x8,%esp
801049ab:	53                   	push   %ebx
801049ac:	57                   	push   %edi
801049ad:	e8 ae ff ff ff       	call   80104960 <pow>
801049b2:	83 c4 10             	add    $0x10,%esp
801049b5:	0f af c7             	imul   %edi,%eax
801049b8:	0f af f0             	imul   %eax,%esi
801049bb:	eb da                	jmp    80104997 <pow+0x37>
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <gcvt>:
  
void gcvt(float num, char* snum, int precision) 
{ 
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	56                   	push   %esi
801049c8:	53                   	push   %ebx
801049c9:	83 ec 10             	sub    $0x10,%esp
801049cc:	d9 45 08             	flds   0x8(%ebp)
801049cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int integer = (int)num; 
801049d2:	d9 7d f6             	fnstcw -0xa(%ebp)
  
    float fraction = num - (float)integer; 
  
    int i = itoa(integer, snum, 0); 
801049d5:	6a 00                	push   $0x0
{ 
801049d7:	8b 75 10             	mov    0x10(%ebp),%esi
    int i = itoa(integer, snum, 0); 
801049da:	53                   	push   %ebx
    int integer = (int)num; 
801049db:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
{ 
801049df:	d9 55 ec             	fsts   -0x14(%ebp)
    int integer = (int)num; 
801049e2:	80 cc 0c             	or     $0xc,%ah
801049e5:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
801049e9:	d9 6d f4             	fldcw  -0xc(%ebp)
801049ec:	db 5d f0             	fistpl -0x10(%ebp)
801049ef:	d9 6d f6             	fldcw  -0xa(%ebp)
    int i = itoa(integer, snum, 0); 
801049f2:	ff 75 f0             	pushl  -0x10(%ebp)
801049f5:	e8 66 fe ff ff       	call   80104860 <itoa>
  
    if (precision != 0) { 
801049fa:	83 c4 0c             	add    $0xc,%esp
801049fd:	85 f6                	test   %esi,%esi
801049ff:	75 0f                	jne    80104a10 <gcvt+0x50>
  
        fraction = fraction * pow(10, precision); 
  
        itoa((int)fraction, snum + i + 1, precision); 
    } 
}
80104a01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a04:	5b                   	pop    %ebx
80104a05:	5e                   	pop    %esi
80104a06:	5d                   	pop    %ebp
80104a07:	c3                   	ret    
80104a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
        fraction = fraction * pow(10, precision); 
80104a10:	83 ec 08             	sub    $0x8,%esp
        snum[i] = '.'; 
80104a13:	c6 04 03 2e          	movb   $0x2e,(%ebx,%eax,1)
80104a17:	89 c2                	mov    %eax,%edx
        fraction = fraction * pow(10, precision); 
80104a19:	56                   	push   %esi
80104a1a:	6a 0a                	push   $0xa
80104a1c:	e8 3f ff ff ff       	call   80104960 <pow>
    float fraction = num - (float)integer; 
80104a21:	db 45 f0             	fildl  -0x10(%ebp)
80104a24:	d8 6d ec             	fsubrs -0x14(%ebp)
        itoa((int)fraction, snum + i + 1, precision); 
80104a27:	89 75 10             	mov    %esi,0x10(%ebp)
80104a2a:	d9 7d f6             	fnstcw -0xa(%ebp)
        fraction = fraction * pow(10, precision); 
80104a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104a30:	db 45 f0             	fildl  -0x10(%ebp)
        itoa((int)fraction, snum + i + 1, precision); 
80104a33:	8d 54 13 01          	lea    0x1(%ebx,%edx,1),%edx
80104a37:	89 55 0c             	mov    %edx,0xc(%ebp)
        fraction = fraction * pow(10, precision); 
80104a3a:	83 c4 10             	add    $0x10,%esp
        itoa((int)fraction, snum + i + 1, precision); 
80104a3d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
        fraction = fraction * pow(10, precision); 
80104a41:	de c9                	fmulp  %st,%st(1)
        itoa((int)fraction, snum + i + 1, precision); 
80104a43:	80 cc 0c             	or     $0xc,%ah
80104a46:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80104a4a:	d9 6d f4             	fldcw  -0xc(%ebp)
80104a4d:	db 5d 08             	fistpl 0x8(%ebp)
80104a50:	d9 6d f6             	fldcw  -0xa(%ebp)
}
80104a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a56:	5b                   	pop    %ebx
80104a57:	5e                   	pop    %esi
80104a58:	5d                   	pop    %ebp
        itoa((int)fraction, snum + i + 1, precision); 
80104a59:	e9 02 fe ff ff       	jmp    80104860 <itoa>
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <find_next_prime_number>:

int 
find_next_prime_number(int n)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	53                   	push   %ebx
  int is_prime = 0;
  int temp = 1; 
  while(!is_prime){
80104a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop
      n++;
80104a70:	83 c3 01             	add    $0x1,%ebx
      temp = 1;
      int i;
      for( i=2; i <= n/i; i++){
80104a73:	83 fb 03             	cmp    $0x3,%ebx
80104a76:	7e 20                	jle    80104a98 <find_next_prime_number+0x38>
          if( n%i == 0 ){
80104a78:	f6 c3 01             	test   $0x1,%bl
80104a7b:	74 f3                	je     80104a70 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104a7d:	b9 02 00 00 00       	mov    $0x2,%ecx
80104a82:	eb 08                	jmp    80104a8c <find_next_prime_number+0x2c>
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if( n%i == 0 ){
80104a88:	85 d2                	test   %edx,%edx
80104a8a:	74 e4                	je     80104a70 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104a8c:	89 d8                	mov    %ebx,%eax
80104a8e:	83 c1 01             	add    $0x1,%ecx
80104a91:	99                   	cltd   
80104a92:	f7 f9                	idiv   %ecx
80104a94:	39 c8                	cmp    %ecx,%eax
80104a96:	7d f0                	jge    80104a88 <find_next_prime_number+0x28>
          } 
      }
      if(temp) is_prime = 1;
  }
  return n;
}
80104a98:	89 d8                	mov    %ebx,%eax
80104a9a:	5b                   	pop    %ebx
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <calculate_rank>:

double calculate_rank(struct proc *p)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	83 ec 08             	sub    $0x8,%esp
80104aaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  float priority_share = p->priority_ratio / p->tickets;
80104aad:	8b 81 00 01 00 00    	mov    0x100(%ecx),%eax
80104ab3:	99                   	cltd   
80104ab4:	f7 b9 fc 00 00 00    	idivl  0xfc(%ecx)
80104aba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  float arrival_time_share = p->arrival_time * p->arrival_time_ratio;
80104abd:	8b 81 f4 00 00 00    	mov    0xf4(%ecx),%eax
80104ac3:	0f af 81 04 01 00 00 	imul   0x104(%ecx),%eax
  float priority_share = p->priority_ratio / p->tickets;
80104aca:	db 45 fc             	fildl  -0x4(%ebp)
  float arrival_time_share = p->arrival_time * p->arrival_time_ratio;
80104acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ad0:	db 45 fc             	fildl  -0x4(%ebp)
  float executed_cycles_share = p->executed_cycles * p->executed_cycles_ratio;
  return (priority_share + arrival_time_share + executed_cycles_share);
80104ad3:	de c1                	faddp  %st,%st(1)
  float executed_cycles_share = p->executed_cycles * p->executed_cycles_ratio;
80104ad5:	db 81 08 01 00 00    	fildl  0x108(%ecx)
80104adb:	d8 89 ec 00 00 00    	fmuls  0xec(%ecx)
}
80104ae1:	c9                   	leave  
  return (priority_share + arrival_time_share + executed_cycles_share);
80104ae2:	de c1                	faddp  %st,%st(1)
}
80104ae4:	c3                   	ret    
80104ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <print_info>:

void print_info(void)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	57                   	push   %edi
      [EXECUTED_CYCLES_RATIO] "executed_cycles_ratio",
      [RANK] "rank",
      [CYCLES] "cycles",
  };
  int min_space_between_words = 8;
  int max_column_lens[] = {
80104af8:	bf 78 88 10 80       	mov    $0x80108878,%edi
{
80104afd:	56                   	push   %esi
      [ARRIVAL_TIME_RATIO] 12 + min_space_between_words,
      [EXECUTED_CYCLES_RATIO] 15 + min_space_between_words,
      [RANK] 5 + min_space_between_words,
      [CYCLES] strlen(titles_str[CYCLES]) + min_space_between_words};

  for (int i = 0; i < table_columns; i++)
80104afe:	31 f6                	xor    %esi,%esi
{
80104b00:	53                   	push   %ebx
80104b01:	89 fb                	mov    %edi,%ebx
80104b03:	81 ec e8 00 00 00    	sub    $0xe8,%esp
  int max_column_lens[] = {
80104b09:	c7 45 c0 12 00 00 00 	movl   $0x12,-0x40(%ebp)
      [PID] strlen(titles_str[PID]) + min_space_between_words,
80104b10:	68 7d 88 10 80       	push   $0x8010887d
80104b15:	e8 86 0c 00 00       	call   801057a0 <strlen>
      [QUEUE_NUM] strlen(titles_str[QUEUE_NUM]) + min_space_between_words,
80104b1a:	c7 04 24 81 88 10 80 	movl   $0x80108881,(%esp)
      [PID] strlen(titles_str[PID]) + min_space_between_words,
80104b21:	83 c0 08             	add    $0x8,%eax
  int max_column_lens[] = {
80104b24:	c7 45 c8 10 00 00 00 	movl   $0x10,-0x38(%ebp)
      [PID] strlen(titles_str[PID]) + min_space_between_words,
80104b2b:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  int max_column_lens[] = {
80104b31:	89 45 c4             	mov    %eax,-0x3c(%ebp)
      [QUEUE_NUM] strlen(titles_str[QUEUE_NUM]) + min_space_between_words,
80104b34:	e8 67 0c 00 00       	call   801057a0 <strlen>
      [TICKET] strlen(titles_str[TICKET]) + min_space_between_words,
80104b39:	c7 04 24 8b 88 10 80 	movl   $0x8010888b,(%esp)
      [QUEUE_NUM] strlen(titles_str[QUEUE_NUM]) + min_space_between_words,
80104b40:	83 c0 08             	add    $0x8,%eax
80104b43:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  int max_column_lens[] = {
80104b49:	89 45 cc             	mov    %eax,-0x34(%ebp)
      [TICKET] strlen(titles_str[TICKET]) + min_space_between_words,
80104b4c:	e8 4f 0c 00 00       	call   801057a0 <strlen>
      [CYCLES] strlen(titles_str[CYCLES]) + min_space_between_words};
80104b51:	c7 04 24 92 88 10 80 	movl   $0x80108892,(%esp)
      [TICKET] strlen(titles_str[TICKET]) + min_space_between_words,
80104b58:	83 c0 08             	add    $0x8,%eax
  int max_column_lens[] = {
80104b5b:	c7 45 d4 12 00 00 00 	movl   $0x12,-0x2c(%ebp)
      [TICKET] strlen(titles_str[TICKET]) + min_space_between_words,
80104b62:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  int max_column_lens[] = {
80104b68:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104b6b:	c7 45 d8 14 00 00 00 	movl   $0x14,-0x28(%ebp)
80104b72:	c7 45 dc 17 00 00 00 	movl   $0x17,-0x24(%ebp)
80104b79:	c7 45 e0 0d 00 00 00 	movl   $0xd,-0x20(%ebp)
      [CYCLES] strlen(titles_str[CYCLES]) + min_space_between_words};
80104b80:	e8 1b 0c 00 00       	call   801057a0 <strlen>
  int max_column_lens[] = {
80104b85:	83 c4 10             	add    $0x10,%esp
      [CYCLES] strlen(titles_str[CYCLES]) + min_space_between_words};
80104b88:	83 c0 08             	add    $0x8,%eax
80104b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < table_columns; i++)
80104b8e:	66 90                	xchg   %ax,%ax
  {
    cprintf("%s", titles_str[i]);
80104b90:	83 ec 08             	sub    $0x8,%esp
80104b93:	53                   	push   %ebx
80104b94:	68 75 88 10 80       	push   $0x80108875
80104b99:	e8 12 bb ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[i] - strlen(titles_str[i]));
80104b9e:	8b 7c b5 c0          	mov    -0x40(%ebp,%esi,4),%edi
80104ba2:	89 1c 24             	mov    %ebx,(%esp)
  for (int i = 0; i < space_ahead; i++)
80104ba5:	31 db                	xor    %ebx,%ebx
    adjust_columns(max_column_lens[i] - strlen(titles_str[i]));
80104ba7:	e8 f4 0b 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104bac:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[i] - strlen(titles_str[i]));
80104baf:	29 c7                	sub    %eax,%edi
  for (int i = 0; i < space_ahead; i++)
80104bb1:	85 ff                	test   %edi,%edi
80104bb3:	7e 1a                	jle    80104bcf <print_info+0xdf>
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" ");
80104bb8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104bbb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80104bbe:	68 4b 89 10 80       	push   $0x8010894b
80104bc3:	e8 e8 ba ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104bc8:	83 c4 10             	add    $0x10,%esp
80104bcb:	39 df                	cmp    %ebx,%edi
80104bcd:	75 e9                	jne    80104bb8 <print_info+0xc8>
  for (int i = 0; i < table_columns; i++)
80104bcf:	83 c6 01             	add    $0x1,%esi
80104bd2:	83 fe 0a             	cmp    $0xa,%esi
80104bd5:	74 09                	je     80104be0 <print_info+0xf0>
80104bd7:	8b 1c b5 80 8a 10 80 	mov    -0x7fef7580(,%esi,4),%ebx
80104bde:	eb b0                	jmp    80104b90 <print_info+0xa0>
  }
  cprintf("\n------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
80104be0:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  char *state;
  int ticket_len;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be3:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  cprintf("\n------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
80104be8:	68 7c 89 10 80       	push   $0x8010897c
80104bed:	e8 be ba ff ff       	call   801006b0 <cprintf>
  acquire(&ptable.lock);
80104bf2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104bf9:	e8 92 08 00 00       	call   80105490 <acquire>
80104bfe:	83 c4 10             	add    $0x10,%esp
80104c01:	eb 17                	jmp    80104c1a <print_info+0x12a>
80104c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c07:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c08:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
80104c0e:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80104c14:	0f 84 e4 03 00 00    	je     80104ffe <print_info+0x50e>
  {
    if (p->pid == 0)
80104c1a:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104c1d:	85 c9                	test   %ecx,%ecx
80104c1f:	74 e7                	je     80104c08 <print_info+0x118>
      continue;
    state = states[p->state];
    cprintf("%s", p->name);
80104c21:	83 ec 08             	sub    $0x8,%esp
    state = states[p->state];
80104c24:	8b 43 0c             	mov    0xc(%ebx),%eax
80104c27:	8d 73 6c             	lea    0x6c(%ebx),%esi
  for (int i = 0; i < space_ahead; i++)
80104c2a:	31 ff                	xor    %edi,%edi
    cprintf("%s", p->name);
80104c2c:	56                   	push   %esi
80104c2d:	68 75 88 10 80       	push   $0x80108875
    state = states[p->state];
80104c32:	8b 04 85 60 8a 10 80 	mov    -0x7fef75a0(,%eax,4),%eax
80104c39:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
    cprintf("%s", p->name);
80104c3f:	e8 6c ba ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[NAME] - strlen(p->name));
80104c44:	89 34 24             	mov    %esi,(%esp)
80104c47:	be 12 00 00 00       	mov    $0x12,%esi
80104c4c:	e8 4f 0b 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104c51:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[NAME] - strlen(p->name));
80104c54:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104c56:	85 f6                	test   %esi,%esi
80104c58:	7e 1d                	jle    80104c77 <print_info+0x187>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104c60:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104c63:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104c66:	68 4b 89 10 80       	push   $0x8010894b
80104c6b:	e8 40 ba ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104c70:	83 c4 10             	add    $0x10,%esp
80104c73:	39 fe                	cmp    %edi,%esi
80104c75:	75 e9                	jne    80104c60 <print_info+0x170>
    cprintf("%d", p->pid);
80104c77:	83 ec 08             	sub    $0x8,%esp
80104c7a:	ff 73 10             	pushl  0x10(%ebx)
    digits = 1;
80104c7d:	be 01 00 00 00       	mov    $0x1,%esi
    cprintf("%d", p->pid);
80104c82:	68 99 88 10 80       	push   $0x80108899
80104c87:	e8 24 ba ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[PID] - count_digits(p->pid));
80104c8c:	8b 4b 10             	mov    0x10(%ebx),%ecx
  if (number == 0)
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c9                	test   %ecx,%ecx
80104c94:	74 1d                	je     80104cb3 <print_info+0x1c3>
  int digits = 0;
80104c96:	31 f6                	xor    %esi,%esi
      number /= 10;
80104c98:	bf 67 66 66 66       	mov    $0x66666667,%edi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ca0:	89 c8                	mov    %ecx,%eax
80104ca2:	c1 f9 1f             	sar    $0x1f,%ecx
      digits++;
80104ca5:	83 c6 01             	add    $0x1,%esi
      number /= 10;
80104ca8:	f7 ef                	imul   %edi
80104caa:	c1 fa 02             	sar    $0x2,%edx
    while(number != 0)
80104cad:	29 ca                	sub    %ecx,%edx
80104caf:	89 d1                	mov    %edx,%ecx
80104cb1:	75 ed                	jne    80104ca0 <print_info+0x1b0>
    adjust_columns(max_column_lens[PID] - count_digits(p->pid));
80104cb3:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  for (int i = 0; i < space_ahead; i++)
80104cb9:	31 ff                	xor    %edi,%edi
    adjust_columns(max_column_lens[PID] - count_digits(p->pid));
80104cbb:	29 f0                	sub    %esi,%eax
80104cbd:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104cbf:	85 c0                	test   %eax,%eax
80104cc1:	7e 1c                	jle    80104cdf <print_info+0x1ef>
80104cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc7:	90                   	nop
    cprintf(" ");
80104cc8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104ccb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104cce:	68 4b 89 10 80       	push   $0x8010894b
80104cd3:	e8 d8 b9 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104cd8:	83 c4 10             	add    $0x10,%esp
80104cdb:	39 fe                	cmp    %edi,%esi
80104cdd:	75 e9                	jne    80104cc8 <print_info+0x1d8>
    cprintf("%s", state);
80104cdf:	8b b5 24 ff ff ff    	mov    -0xdc(%ebp),%esi
80104ce5:	83 ec 08             	sub    $0x8,%esp
  for (int i = 0; i < space_ahead; i++)
80104ce8:	31 ff                	xor    %edi,%edi
    cprintf("%s", state);
80104cea:	56                   	push   %esi
80104ceb:	68 75 88 10 80       	push   $0x80108875
80104cf0:	e8 bb b9 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[STATE] - strlen(state));
80104cf5:	89 34 24             	mov    %esi,(%esp)
80104cf8:	be 10 00 00 00       	mov    $0x10,%esi
80104cfd:	e8 9e 0a 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104d02:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[STATE] - strlen(state));
80104d05:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104d07:	85 f6                	test   %esi,%esi
80104d09:	7e 1c                	jle    80104d27 <print_info+0x237>
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop
    cprintf(" ");
80104d10:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104d13:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104d16:	68 4b 89 10 80       	push   $0x8010894b
80104d1b:	e8 90 b9 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104d20:	83 c4 10             	add    $0x10,%esp
80104d23:	39 fe                	cmp    %edi,%esi
80104d25:	75 e9                	jne    80104d10 <print_info+0x220>
    cprintf("%d", p->q_num);
80104d27:	83 ec 08             	sub    $0x8,%esp
80104d2a:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
    digits = 1;
80104d30:	be 01 00 00 00       	mov    $0x1,%esi
    cprintf("%d", p->q_num);
80104d35:	68 99 88 10 80       	push   $0x80108899
80104d3a:	e8 71 b9 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[QUEUE_NUM] - count_digits(p->q_num));
80104d3f:	8b 8b e4 00 00 00    	mov    0xe4(%ebx),%ecx
  if (number == 0)
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	85 c9                	test   %ecx,%ecx
80104d4a:	74 1f                	je     80104d6b <print_info+0x27b>
  int digits = 0;
80104d4c:	31 f6                	xor    %esi,%esi
      number /= 10;
80104d4e:	bf 67 66 66 66       	mov    $0x66666667,%edi
80104d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d57:	90                   	nop
80104d58:	89 c8                	mov    %ecx,%eax
80104d5a:	c1 f9 1f             	sar    $0x1f,%ecx
      digits++;
80104d5d:	83 c6 01             	add    $0x1,%esi
      number /= 10;
80104d60:	f7 ef                	imul   %edi
80104d62:	c1 fa 02             	sar    $0x2,%edx
    while(number != 0)
80104d65:	29 ca                	sub    %ecx,%edx
80104d67:	89 d1                	mov    %edx,%ecx
80104d69:	75 ed                	jne    80104d58 <print_info+0x268>
    adjust_columns(max_column_lens[QUEUE_NUM] - count_digits(p->q_num));
80104d6b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  for (int i = 0; i < space_ahead; i++)
80104d71:	31 ff                	xor    %edi,%edi
    adjust_columns(max_column_lens[QUEUE_NUM] - count_digits(p->q_num));
80104d73:	29 f0                	sub    %esi,%eax
80104d75:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104d77:	85 c0                	test   %eax,%eax
80104d79:	7e 1c                	jle    80104d97 <print_info+0x2a7>
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop
    cprintf(" ");
80104d80:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104d83:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104d86:	68 4b 89 10 80       	push   $0x8010894b
80104d8b:	e8 20 b9 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	39 fe                	cmp    %edi,%esi
80104d95:	75 e9                	jne    80104d80 <print_info+0x290>
    cprintf("%d", p->tickets);
80104d97:	83 ec 08             	sub    $0x8,%esp
80104d9a:	ff b3 fc 00 00 00    	pushl  0xfc(%ebx)
    digits = 1;
80104da0:	be 01 00 00 00       	mov    $0x1,%esi
    cprintf("%d", p->tickets);
80104da5:	68 99 88 10 80       	push   $0x80108899
80104daa:	e8 01 b9 ff ff       	call   801006b0 <cprintf>

    ticket_len = count_digits(p->tickets);
80104daf:	8b 8b fc 00 00 00    	mov    0xfc(%ebx),%ecx
  if (number == 0)
80104db5:	83 c4 10             	add    $0x10,%esp
80104db8:	85 c9                	test   %ecx,%ecx
80104dba:	74 1f                	je     80104ddb <print_info+0x2eb>
  int digits = 0;
80104dbc:	31 f6                	xor    %esi,%esi
      number /= 10;
80104dbe:	bf 67 66 66 66       	mov    $0x66666667,%edi
80104dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc7:	90                   	nop
80104dc8:	89 c8                	mov    %ecx,%eax
80104dca:	c1 f9 1f             	sar    $0x1f,%ecx
      digits++;
80104dcd:	83 c6 01             	add    $0x1,%esi
      number /= 10;
80104dd0:	f7 ef                	imul   %edi
80104dd2:	c1 fa 02             	sar    $0x2,%edx
    while(number != 0)
80104dd5:	29 ca                	sub    %ecx,%edx
80104dd7:	89 d1                	mov    %edx,%ecx
80104dd9:	75 ed                	jne    80104dc8 <print_info+0x2d8>

    adjust_columns(max_column_lens[TICKET] - ticket_len);
80104ddb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  for (int i = 0; i < space_ahead; i++)
80104de1:	31 ff                	xor    %edi,%edi
    adjust_columns(max_column_lens[TICKET] - ticket_len);
80104de3:	29 f0                	sub    %esi,%eax
80104de5:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104de7:	85 c0                	test   %eax,%eax
80104de9:	7e 1c                	jle    80104e07 <print_info+0x317>
80104deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop
    cprintf(" ");
80104df0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104df3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104df6:	68 4b 89 10 80       	push   $0x8010894b
80104dfb:	e8 b0 b8 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104e00:	83 c4 10             	add    $0x10,%esp
80104e03:	39 fe                	cmp    %edi,%esi
80104e05:	75 e9                	jne    80104df0 <print_info+0x300>

    char priority_ratio_str[30];
    gcvt(p->priority_ratio, priority_ratio_str, 0);
80104e07:	8d b5 2a ff ff ff    	lea    -0xd6(%ebp),%esi
80104e0d:	83 ec 04             	sub    $0x4,%esp
  for (int i = 0; i < space_ahead; i++)
80104e10:	31 ff                	xor    %edi,%edi
    gcvt(p->priority_ratio, priority_ratio_str, 0);
80104e12:	6a 00                	push   $0x0
80104e14:	56                   	push   %esi
80104e15:	db 83 00 01 00 00    	fildl  0x100(%ebx)
80104e1b:	83 ec 04             	sub    $0x4,%esp
80104e1e:	d9 1c 24             	fstps  (%esp)
80104e21:	e8 9a fb ff ff       	call   801049c0 <gcvt>
    cprintf("%s", priority_ratio_str);
80104e26:	58                   	pop    %eax
80104e27:	5a                   	pop    %edx
80104e28:	56                   	push   %esi
80104e29:	68 75 88 10 80       	push   $0x80108875
80104e2e:	e8 7d b8 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[PRIORITY_RATIO] - strlen(priority_ratio_str));
80104e33:	89 34 24             	mov    %esi,(%esp)
80104e36:	be 12 00 00 00       	mov    $0x12,%esi
80104e3b:	e8 60 09 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104e40:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[PRIORITY_RATIO] - strlen(priority_ratio_str));
80104e43:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104e45:	85 f6                	test   %esi,%esi
80104e47:	7e 1e                	jle    80104e67 <print_info+0x377>
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104e50:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104e53:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104e56:	68 4b 89 10 80       	push   $0x8010894b
80104e5b:	e8 50 b8 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104e60:	83 c4 10             	add    $0x10,%esp
80104e63:	39 fe                	cmp    %edi,%esi
80104e65:	75 e9                	jne    80104e50 <print_info+0x360>

    char arrival_time_ratio_str[30];
    gcvt(p->arrival_time_ratio, arrival_time_ratio_str, 0);
80104e67:	8d b5 48 ff ff ff    	lea    -0xb8(%ebp),%esi
80104e6d:	83 ec 04             	sub    $0x4,%esp
80104e70:	6a 00                	push   $0x0
80104e72:	56                   	push   %esi
80104e73:	db 83 04 01 00 00    	fildl  0x104(%ebx)
80104e79:	83 ec 04             	sub    $0x4,%esp
80104e7c:	d9 1c 24             	fstps  (%esp)
80104e7f:	e8 3c fb ff ff       	call   801049c0 <gcvt>
    cprintf("%s", arrival_time_ratio_str);
80104e84:	59                   	pop    %ecx
80104e85:	5f                   	pop    %edi
80104e86:	56                   	push   %esi
80104e87:	68 75 88 10 80       	push   $0x80108875
  for (int i = 0; i < space_ahead; i++)
80104e8c:	31 ff                	xor    %edi,%edi
    cprintf("%s", arrival_time_ratio_str);
80104e8e:	e8 1d b8 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[ARRIVAL_TIME_RATIO] - strlen(arrival_time_ratio_str));
80104e93:	89 34 24             	mov    %esi,(%esp)
80104e96:	be 14 00 00 00       	mov    $0x14,%esi
80104e9b:	e8 00 09 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104ea0:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[ARRIVAL_TIME_RATIO] - strlen(arrival_time_ratio_str));
80104ea3:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104ea5:	85 f6                	test   %esi,%esi
80104ea7:	7e 1e                	jle    80104ec7 <print_info+0x3d7>
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104eb0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104eb3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104eb6:	68 4b 89 10 80       	push   $0x8010894b
80104ebb:	e8 f0 b7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	39 fe                	cmp    %edi,%esi
80104ec5:	75 e9                	jne    80104eb0 <print_info+0x3c0>


    char executed_cycles_ratio_str[30];
    gcvt(p->executed_cycles_ratio, executed_cycles_ratio_str, 0);
80104ec7:	8d b5 66 ff ff ff    	lea    -0x9a(%ebp),%esi
80104ecd:	83 ec 04             	sub    $0x4,%esp
  for (int i = 0; i < space_ahead; i++)
80104ed0:	31 ff                	xor    %edi,%edi
    gcvt(p->executed_cycles_ratio, executed_cycles_ratio_str, 0);
80104ed2:	6a 00                	push   $0x0
80104ed4:	56                   	push   %esi
80104ed5:	db 83 08 01 00 00    	fildl  0x108(%ebx)
80104edb:	83 ec 04             	sub    $0x4,%esp
80104ede:	d9 1c 24             	fstps  (%esp)
80104ee1:	e8 da fa ff ff       	call   801049c0 <gcvt>
    cprintf("%s", executed_cycles_ratio_str);
80104ee6:	58                   	pop    %eax
80104ee7:	5a                   	pop    %edx
80104ee8:	56                   	push   %esi
80104ee9:	68 75 88 10 80       	push   $0x80108875
80104eee:	e8 bd b7 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[EXECUTED_CYCLES_RATIO] - strlen(executed_cycles_ratio_str));
80104ef3:	89 34 24             	mov    %esi,(%esp)
80104ef6:	be 17 00 00 00       	mov    $0x17,%esi
80104efb:	e8 a0 08 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104f00:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[EXECUTED_CYCLES_RATIO] - strlen(executed_cycles_ratio_str));
80104f03:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104f05:	85 f6                	test   %esi,%esi
80104f07:	7e 1e                	jle    80104f27 <print_info+0x437>
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104f10:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104f13:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104f16:	68 4b 89 10 80       	push   $0x8010894b
80104f1b:	e8 90 b7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104f20:	83 c4 10             	add    $0x10,%esp
80104f23:	39 fe                	cmp    %edi,%esi
80104f25:	75 e9                	jne    80104f10 <print_info+0x420>


    double rank = calculate_rank(p);

    char rank_str[30];
    gcvt(rank, rank_str, RATIO_PRECISION);
80104f27:	8d 75 84             	lea    -0x7c(%ebp),%esi
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	6a 03                	push   $0x3
80104f2f:	56                   	push   %esi
  float priority_share = p->priority_ratio / p->tickets;
80104f30:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
80104f36:	99                   	cltd   
80104f37:	f7 bb fc 00 00 00    	idivl  0xfc(%ebx)
    gcvt(rank, rank_str, RATIO_PRECISION);
80104f3d:	83 ec 04             	sub    $0x4,%esp
  float priority_share = p->priority_ratio / p->tickets;
80104f40:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  float arrival_time_share = p->arrival_time * p->arrival_time_ratio;
80104f46:	8b 83 f4 00 00 00    	mov    0xf4(%ebx),%eax
80104f4c:	0f af 83 04 01 00 00 	imul   0x104(%ebx),%eax
  float priority_share = p->priority_ratio / p->tickets;
80104f53:	db 85 24 ff ff ff    	fildl  -0xdc(%ebp)
  float arrival_time_share = p->arrival_time * p->arrival_time_ratio;
80104f59:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
80104f5f:	db 85 24 ff ff ff    	fildl  -0xdc(%ebp)
  return (priority_share + arrival_time_share + executed_cycles_share);
80104f65:	de c1                	faddp  %st,%st(1)
  float executed_cycles_share = p->executed_cycles * p->executed_cycles_ratio;
80104f67:	db 83 08 01 00 00    	fildl  0x108(%ebx)
80104f6d:	d8 8b ec 00 00 00    	fmuls  0xec(%ebx)
  return (priority_share + arrival_time_share + executed_cycles_share);
80104f73:	de c1                	faddp  %st,%st(1)
    gcvt(rank, rank_str, RATIO_PRECISION);
80104f75:	d9 1c 24             	fstps  (%esp)
80104f78:	e8 43 fa ff ff       	call   801049c0 <gcvt>

    cprintf("%s", rank_str);
80104f7d:	59                   	pop    %ecx
80104f7e:	5f                   	pop    %edi
80104f7f:	56                   	push   %esi
80104f80:	68 75 88 10 80       	push   $0x80108875
  for (int i = 0; i < space_ahead; i++)
80104f85:	31 ff                	xor    %edi,%edi
    cprintf("%s", rank_str);
80104f87:	e8 24 b7 ff ff       	call   801006b0 <cprintf>
    adjust_columns(max_column_lens[RANK] - strlen(rank_str));
80104f8c:	89 34 24             	mov    %esi,(%esp)
80104f8f:	be 0d 00 00 00       	mov    $0xd,%esi
80104f94:	e8 07 08 00 00       	call   801057a0 <strlen>
  for (int i = 0; i < space_ahead; i++)
80104f99:	83 c4 10             	add    $0x10,%esp
    adjust_columns(max_column_lens[RANK] - strlen(rank_str));
80104f9c:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < space_ahead; i++)
80104f9e:	85 f6                	test   %esi,%esi
80104fa0:	7e 1d                	jle    80104fbf <print_info+0x4cf>
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104fa8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < space_ahead; i++)
80104fab:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104fae:	68 4b 89 10 80       	push   $0x8010894b
80104fb3:	e8 f8 b6 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < space_ahead; i++)
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	39 fe                	cmp    %edi,%esi
80104fbd:	75 e9                	jne    80104fa8 <print_info+0x4b8>
    
    char cycles_str[30];
    gcvt(p->executed_cycles, cycles_str, CYCLES_PRECISION);
80104fbf:	83 ec 04             	sub    $0x4,%esp
80104fc2:	8d 75 a2             	lea    -0x5e(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fc5:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
    gcvt(p->executed_cycles, cycles_str, CYCLES_PRECISION);
80104fcb:	6a 01                	push   $0x1
80104fcd:	56                   	push   %esi
80104fce:	ff 73 e0             	pushl  -0x20(%ebx)
80104fd1:	e8 ea f9 ff ff       	call   801049c0 <gcvt>

    cprintf("%s\n", cycles_str);
80104fd6:	58                   	pop    %eax
80104fd7:	5a                   	pop    %edx
80104fd8:	56                   	push   %esi
80104fd9:	68 9c 88 10 80       	push   $0x8010889c
80104fde:	e8 cd b6 ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
80104fe3:	c7 04 24 b6 88 10 80 	movl   $0x801088b6,(%esp)
80104fea:	e8 c1 b6 ff ff       	call   801006b0 <cprintf>
80104fef:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff2:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80104ff8:	0f 85 1c fc ff ff    	jne    80104c1a <print_info+0x12a>
  }
  release(&ptable.lock);
80104ffe:	83 ec 0c             	sub    $0xc,%esp
80105001:	68 20 3d 11 80       	push   $0x80113d20
80105006:	e8 45 05 00 00       	call   80105550 <release>
}
8010500b:	83 c4 10             	add    $0x10,%esp
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5f                   	pop    %edi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi

80105020 <wait_for_process>:

int
wait_for_process(int proc_pid)
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	57                   	push   %edi
80105028:	56                   	push   %esi
80105029:	53                   	push   %ebx
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105030:	e8 5b 03 00 00       	call   80105390 <pushcli>
  c = mycpu();
80105035:	e8 16 e9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010503a:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80105040:	e8 9b 03 00 00       	call   801053e0 <popcli>
  struct proc *p;
  struct proc *curproc = myproc();
  int exist=0;
  acquire(&ptable.lock);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	68 20 3d 11 80       	push   $0x80113d20
8010504d:	e8 3e 04 00 00       	call   80105490 <acquire>
80105052:	83 c4 10             	add    $0x10,%esp
  for(;;){
    exist=0;
80105055:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105057:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010505c:	eb 10                	jmp    8010506e <wait_for_process+0x4e>
8010505e:	66 90                	xchg   %ax,%ax
80105060:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
80105066:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
8010506c:	74 1e                	je     8010508c <wait_for_process+0x6c>
      if(p->pid == proc_pid)
8010506e:	39 73 10             	cmp    %esi,0x10(%ebx)
80105071:	75 ed                	jne    80105060 <wait_for_process+0x40>
        exist = 1;
      if(p->state == ZOMBIE && p->pid == proc_pid){
80105073:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105077:	74 37                	je     801050b0 <wait_for_process+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105079:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
        exist = 1;
8010507f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105084:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
8010508a:	75 e2                	jne    8010506e <wait_for_process+0x4e>
        p->state = UNUSED;
        release(&ptable.lock);
        return proc_pid;
      }
    }
    if(!exist || curproc->killed){
8010508c:	85 c0                	test   %eax,%eax
8010508e:	74 74                	je     80105104 <wait_for_process+0xe4>
80105090:	8b 47 24             	mov    0x24(%edi),%eax
80105093:	85 c0                	test   %eax,%eax
80105095:	75 6d                	jne    80105104 <wait_for_process+0xe4>
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	68 20 3d 11 80       	push   $0x80113d20
8010509f:	57                   	push   %edi
801050a0:	e8 4b f2 ff ff       	call   801042f0 <sleep>
    exist=0;
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	eb ab                	jmp    80105055 <wait_for_process+0x35>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	ff 73 08             	pushl  0x8(%ebx)
801050b6:	e8 c5 d3 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
801050bb:	5a                   	pop    %edx
801050bc:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801050bf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801050c6:	e8 a5 2e 00 00       	call   80107f70 <freevm>
        release(&ptable.lock);
801050cb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801050d2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801050d9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801050e0:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801050e4:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801050eb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801050f2:	e8 59 04 00 00       	call   80105550 <release>
        return proc_pid;
801050f7:	83 c4 10             	add    $0x10,%esp
801050fa:	89 f0                	mov    %esi,%eax
  }
}
801050fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5f                   	pop    %edi
80105102:	5d                   	pop    %ebp
80105103:	c3                   	ret    
      release(&ptable.lock);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	68 20 3d 11 80       	push   $0x80113d20
8010510c:	e8 3f 04 00 00       	call   80105550 <release>
      return -1;
80105111:	83 c4 10             	add    $0x10,%esp
80105114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105119:	eb e1                	jmp    801050fc <wait_for_process+0xdc>
8010511b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010511f:	90                   	nop

80105120 <get_most_caller>:

int 
get_most_caller(int sys_num)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	57                   	push   %edi
  struct proc *p;
  int pid_max = -1;
  int cnt_max = -1;
80105128:	bf ff ff ff ff       	mov    $0xffffffff,%edi
{
8010512d:	56                   	push   %esi
8010512e:	53                   	push   %ebx
  acquire(&ptable.lock);
  cprintf("Kernel: The list of onging processes:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010512f:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80105134:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80105137:	68 20 3d 11 80       	push   $0x80113d20
8010513c:	e8 4f 03 00 00       	call   80105490 <acquire>
  cprintf("Kernel: The list of onging processes:\n");
80105141:	c7 04 24 1c 8a 10 80 	movl   $0x80108a1c,(%esp)
80105148:	e8 63 b5 ff ff       	call   801006b0 <cprintf>
    int * sys_cnt = p->syscnt;
    int cnt = *(sys_cnt+sys_num-1);
8010514d:	8b 45 08             	mov    0x8(%ebp),%eax
  int pid_max = -1;
80105150:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    int cnt = *(sys_cnt+sys_num-1);
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	8d 14 85 fc ff ff ff 	lea    -0x4(,%eax,4),%edx
80105161:	eb 1f                	jmp    80105182 <get_most_caller+0x62>
80105163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105167:	90                   	nop
    if(p->pid !=0)
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
    if(cnt >= cnt_max){
80105168:	39 fe                	cmp    %edi,%esi
8010516a:	7c 08                	jl     80105174 <get_most_caller+0x54>
      cnt_max = cnt;
      pid_max = p->pid;
8010516c:	8b 43 10             	mov    0x10(%ebx),%eax
8010516f:	89 f7                	mov    %esi,%edi
80105171:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105174:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
8010517a:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80105180:	74 2e                	je     801051b0 <get_most_caller+0x90>
    if(p->pid !=0)
80105182:	8b 43 10             	mov    0x10(%ebx),%eax
    int cnt = *(sys_cnt+sys_num-1);
80105185:	8b 74 13 7c          	mov    0x7c(%ebx,%edx,1),%esi
    if(p->pid !=0)
80105189:	85 c0                	test   %eax,%eax
8010518b:	74 db                	je     80105168 <get_most_caller+0x48>
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
8010518d:	83 ec 04             	sub    $0x4,%esp
80105190:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80105193:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105196:	51                   	push   %ecx
80105197:	50                   	push   %eax
80105198:	68 a0 88 10 80       	push   $0x801088a0
8010519d:	e8 0e b5 ff ff       	call   801006b0 <cprintf>
801051a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801051a5:	83 c4 10             	add    $0x10,%esp
801051a8:	eb be                	jmp    80105168 <get_most_caller+0x48>
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }

  }
  release(&ptable.lock);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	68 20 3d 11 80       	push   $0x80113d20
801051b8:	e8 93 03 00 00       	call   80105550 <release>
  return pid_max;
}
801051bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c3:	5b                   	pop    %ebx
801051c4:	5e                   	pop    %esi
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    
801051c8:	66 90                	xchg   %ax,%ax
801051ca:	66 90                	xchg   %ax,%ax
801051cc:	66 90                	xchg   %ax,%ax
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	53                   	push   %ebx
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801051de:	68 d0 8a 10 80       	push   $0x80108ad0
801051e3:	8d 43 04             	lea    0x4(%ebx),%eax
801051e6:	50                   	push   %eax
801051e7:	e8 24 01 00 00       	call   80105310 <initlock>
  lk->name = name;
801051ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801051ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801051f5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801051f8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801051ff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	53                   	push   %ebx
80105219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010521c:	8d 73 04             	lea    0x4(%ebx),%esi
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	56                   	push   %esi
80105223:	e8 68 02 00 00       	call   80105490 <acquire>
  while (lk->locked) {
80105228:	8b 13                	mov    (%ebx),%edx
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 d2                	test   %edx,%edx
8010522f:	74 1a                	je     8010524b <acquiresleep+0x3b>
80105231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105238:	83 ec 08             	sub    $0x8,%esp
8010523b:	56                   	push   %esi
8010523c:	53                   	push   %ebx
8010523d:	e8 ae f0 ff ff       	call   801042f0 <sleep>
  while (lk->locked) {
80105242:	8b 03                	mov    (%ebx),%eax
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	75 ed                	jne    80105238 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010524b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105251:	e8 8a e7 ff ff       	call   801039e0 <myproc>
80105256:	8b 40 10             	mov    0x10(%eax),%eax
80105259:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010525c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010525f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105262:	5b                   	pop    %ebx
80105263:	5e                   	pop    %esi
80105264:	5d                   	pop    %ebp
  release(&lk->lk);
80105265:	e9 e6 02 00 00       	jmp    80105550 <release>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105270 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	56                   	push   %esi
80105278:	53                   	push   %ebx
80105279:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010527c:	8d 73 04             	lea    0x4(%ebx),%esi
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	56                   	push   %esi
80105283:	e8 08 02 00 00       	call   80105490 <acquire>
  lk->locked = 0;
80105288:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010528e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105295:	89 1c 24             	mov    %ebx,(%esp)
80105298:	e8 13 f2 ff ff       	call   801044b0 <wakeup>
  release(&lk->lk);
8010529d:	89 75 08             	mov    %esi,0x8(%ebp)
801052a0:	83 c4 10             	add    $0x10,%esp
}
801052a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a6:	5b                   	pop    %ebx
801052a7:	5e                   	pop    %esi
801052a8:	5d                   	pop    %ebp
  release(&lk->lk);
801052a9:	e9 a2 02 00 00       	jmp    80105550 <release>
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	57                   	push   %edi
801052b8:	31 ff                	xor    %edi,%edi
801052ba:	56                   	push   %esi
801052bb:	53                   	push   %ebx
801052bc:	83 ec 18             	sub    $0x18,%esp
801052bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801052c2:	8d 73 04             	lea    0x4(%ebx),%esi
801052c5:	56                   	push   %esi
801052c6:	e8 c5 01 00 00       	call   80105490 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801052cb:	8b 03                	mov    (%ebx),%eax
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	75 1c                	jne    801052f0 <holdingsleep+0x40>
  release(&lk->lk);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	56                   	push   %esi
801052d8:	e8 73 02 00 00       	call   80105550 <release>
  return r;
}
801052dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e0:	89 f8                	mov    %edi,%eax
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5f                   	pop    %edi
801052e5:	5d                   	pop    %ebp
801052e6:	c3                   	ret    
801052e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ee:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801052f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801052f3:	e8 e8 e6 ff ff       	call   801039e0 <myproc>
801052f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801052fb:	0f 94 c0             	sete   %al
801052fe:	0f b6 c0             	movzbl %al,%eax
80105301:	89 c7                	mov    %eax,%edi
80105303:	eb cf                	jmp    801052d4 <holdingsleep+0x24>
80105305:	66 90                	xchg   %ax,%ax
80105307:	66 90                	xchg   %ax,%ax
80105309:	66 90                	xchg   %ax,%ax
8010530b:	66 90                	xchg   %ax,%ax
8010530d:	66 90                	xchg   %ax,%ax
8010530f:	90                   	nop

80105310 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010531a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010531d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105323:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105326:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010532d:	5d                   	pop    %ebp
8010532e:	c3                   	ret    
8010532f:	90                   	nop

80105330 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105335:	31 d2                	xor    %edx,%edx
{
80105337:	89 e5                	mov    %esp,%ebp
80105339:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010533a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010533d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105340:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105347:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105348:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010534e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105354:	77 1a                	ja     80105370 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105356:	8b 58 04             	mov    0x4(%eax),%ebx
80105359:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010535c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010535f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105361:	83 fa 0a             	cmp    $0xa,%edx
80105364:	75 e2                	jne    80105348 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105366:	5b                   	pop    %ebx
80105367:	5d                   	pop    %ebp
80105368:	c3                   	ret    
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105370:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105373:	8d 51 28             	lea    0x28(%ecx),%edx
80105376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105386:	83 c0 04             	add    $0x4,%eax
80105389:	39 d0                	cmp    %edx,%eax
8010538b:	75 f3                	jne    80105380 <getcallerpcs+0x50>
}
8010538d:	5b                   	pop    %ebx
8010538e:	5d                   	pop    %ebp
8010538f:	c3                   	ret    

80105390 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	53                   	push   %ebx
80105398:	83 ec 04             	sub    $0x4,%esp
8010539b:	9c                   	pushf  
8010539c:	5b                   	pop    %ebx
  asm volatile("cli");
8010539d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010539e:	e8 ad e5 ff ff       	call   80103950 <mycpu>
801053a3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801053a9:	85 c0                	test   %eax,%eax
801053ab:	74 13                	je     801053c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801053ad:	e8 9e e5 ff ff       	call   80103950 <mycpu>
801053b2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801053b9:	83 c4 04             	add    $0x4,%esp
801053bc:	5b                   	pop    %ebx
801053bd:	5d                   	pop    %ebp
801053be:	c3                   	ret    
801053bf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801053c0:	e8 8b e5 ff ff       	call   80103950 <mycpu>
801053c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801053cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801053d1:	eb da                	jmp    801053ad <pushcli+0x1d>
801053d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053e0 <popcli>:

void
popcli(void)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801053ea:	9c                   	pushf  
801053eb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801053ec:	f6 c4 02             	test   $0x2,%ah
801053ef:	75 31                	jne    80105422 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801053f1:	e8 5a e5 ff ff       	call   80103950 <mycpu>
801053f6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801053fd:	78 30                	js     8010542f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801053ff:	e8 4c e5 ff ff       	call   80103950 <mycpu>
80105404:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010540a:	85 d2                	test   %edx,%edx
8010540c:	74 02                	je     80105410 <popcli+0x30>
    sti();
}
8010540e:	c9                   	leave  
8010540f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105410:	e8 3b e5 ff ff       	call   80103950 <mycpu>
80105415:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010541b:	85 c0                	test   %eax,%eax
8010541d:	74 ef                	je     8010540e <popcli+0x2e>
  asm volatile("sti");
8010541f:	fb                   	sti    
}
80105420:	c9                   	leave  
80105421:	c3                   	ret    
    panic("popcli - interruptible");
80105422:	83 ec 0c             	sub    $0xc,%esp
80105425:	68 db 8a 10 80       	push   $0x80108adb
8010542a:	e8 61 af ff ff       	call   80100390 <panic>
    panic("popcli");
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	68 f2 8a 10 80       	push   $0x80108af2
80105437:	e8 54 af ff ff       	call   80100390 <panic>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <holding>:
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	56                   	push   %esi
80105448:	53                   	push   %ebx
80105449:	8b 75 08             	mov    0x8(%ebp),%esi
8010544c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010544e:	e8 3d ff ff ff       	call   80105390 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105453:	8b 06                	mov    (%esi),%eax
80105455:	85 c0                	test   %eax,%eax
80105457:	75 0f                	jne    80105468 <holding+0x28>
  popcli();
80105459:	e8 82 ff ff ff       	call   801053e0 <popcli>
}
8010545e:	89 d8                	mov    %ebx,%eax
80105460:	5b                   	pop    %ebx
80105461:	5e                   	pop    %esi
80105462:	5d                   	pop    %ebp
80105463:	c3                   	ret    
80105464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105468:	8b 5e 08             	mov    0x8(%esi),%ebx
8010546b:	e8 e0 e4 ff ff       	call   80103950 <mycpu>
80105470:	39 c3                	cmp    %eax,%ebx
80105472:	0f 94 c3             	sete   %bl
  popcli();
80105475:	e8 66 ff ff ff       	call   801053e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010547a:	0f b6 db             	movzbl %bl,%ebx
}
8010547d:	89 d8                	mov    %ebx,%eax
8010547f:	5b                   	pop    %ebx
80105480:	5e                   	pop    %esi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <acquire>:
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	56                   	push   %esi
80105498:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105499:	e8 f2 fe ff ff       	call   80105390 <pushcli>
  if(holding(lk))
8010549e:	8b 5d 08             	mov    0x8(%ebp),%ebx
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	53                   	push   %ebx
801054a5:	e8 96 ff ff ff       	call   80105440 <holding>
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	85 c0                	test   %eax,%eax
801054af:	0f 85 7f 00 00 00    	jne    80105534 <acquire+0xa4>
801054b5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801054b7:	ba 01 00 00 00       	mov    $0x1,%edx
801054bc:	eb 05                	jmp    801054c3 <acquire+0x33>
801054be:	66 90                	xchg   %ax,%ax
801054c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801054c3:	89 d0                	mov    %edx,%eax
801054c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801054c8:	85 c0                	test   %eax,%eax
801054ca:	75 f4                	jne    801054c0 <acquire+0x30>
  __sync_synchronize();
801054cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801054d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801054d4:	e8 77 e4 ff ff       	call   80103950 <mycpu>
801054d9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801054dc:	89 e8                	mov    %ebp,%eax
801054de:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054e0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801054e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801054ec:	77 22                	ja     80105510 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801054ee:	8b 50 04             	mov    0x4(%eax),%edx
801054f1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801054f5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801054f8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801054fa:	83 fe 0a             	cmp    $0xa,%esi
801054fd:	75 e1                	jne    801054e0 <acquire+0x50>
}
801054ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105502:	5b                   	pop    %ebx
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105510:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105514:	83 c3 34             	add    $0x34,%ebx
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105526:	83 c0 04             	add    $0x4,%eax
80105529:	39 d8                	cmp    %ebx,%eax
8010552b:	75 f3                	jne    80105520 <acquire+0x90>
}
8010552d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105530:	5b                   	pop    %ebx
80105531:	5e                   	pop    %esi
80105532:	5d                   	pop    %ebp
80105533:	c3                   	ret    
    panic("acquire");
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	68 f9 8a 10 80       	push   $0x80108af9
8010553c:	e8 4f ae ff ff       	call   80100390 <panic>
80105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <release>:
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	53                   	push   %ebx
80105558:	83 ec 10             	sub    $0x10,%esp
8010555b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010555e:	53                   	push   %ebx
8010555f:	e8 dc fe ff ff       	call   80105440 <holding>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	74 22                	je     8010558d <release+0x3d>
  lk->pcs[0] = 0;
8010556b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105572:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105579:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010557e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105587:	c9                   	leave  
  popcli();
80105588:	e9 53 fe ff ff       	jmp    801053e0 <popcli>
    panic("release");
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	68 01 8b 10 80       	push   $0x80108b01
80105595:	e8 f6 ad ff ff       	call   80100390 <panic>
8010559a:	66 90                	xchg   %ax,%ax
8010559c:	66 90                	xchg   %ax,%ax
8010559e:	66 90                	xchg   %ax,%ax

801055a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	57                   	push   %edi
801055a8:	8b 55 08             	mov    0x8(%ebp),%edx
801055ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801055ae:	53                   	push   %ebx
801055af:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801055b2:	89 d7                	mov    %edx,%edi
801055b4:	09 cf                	or     %ecx,%edi
801055b6:	83 e7 03             	and    $0x3,%edi
801055b9:	75 25                	jne    801055e0 <memset+0x40>
    c &= 0xFF;
801055bb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801055be:	c1 e0 18             	shl    $0x18,%eax
801055c1:	89 fb                	mov    %edi,%ebx
801055c3:	c1 e9 02             	shr    $0x2,%ecx
801055c6:	c1 e3 10             	shl    $0x10,%ebx
801055c9:	09 d8                	or     %ebx,%eax
801055cb:	09 f8                	or     %edi,%eax
801055cd:	c1 e7 08             	shl    $0x8,%edi
801055d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801055d2:	89 d7                	mov    %edx,%edi
801055d4:	fc                   	cld    
801055d5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801055d7:	5b                   	pop    %ebx
801055d8:	89 d0                	mov    %edx,%eax
801055da:	5f                   	pop    %edi
801055db:	5d                   	pop    %ebp
801055dc:	c3                   	ret    
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801055e0:	89 d7                	mov    %edx,%edi
801055e2:	fc                   	cld    
801055e3:	f3 aa                	rep stos %al,%es:(%edi)
801055e5:	5b                   	pop    %ebx
801055e6:	89 d0                	mov    %edx,%eax
801055e8:	5f                   	pop    %edi
801055e9:	5d                   	pop    %ebp
801055ea:	c3                   	ret    
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop

801055f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	56                   	push   %esi
801055f8:	8b 75 10             	mov    0x10(%ebp),%esi
801055fb:	8b 55 08             	mov    0x8(%ebp),%edx
801055fe:	53                   	push   %ebx
801055ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105602:	85 f6                	test   %esi,%esi
80105604:	74 2a                	je     80105630 <memcmp+0x40>
80105606:	01 c6                	add    %eax,%esi
80105608:	eb 10                	jmp    8010561a <memcmp+0x2a>
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105610:	83 c0 01             	add    $0x1,%eax
80105613:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105616:	39 f0                	cmp    %esi,%eax
80105618:	74 16                	je     80105630 <memcmp+0x40>
    if(*s1 != *s2)
8010561a:	0f b6 0a             	movzbl (%edx),%ecx
8010561d:	0f b6 18             	movzbl (%eax),%ebx
80105620:	38 d9                	cmp    %bl,%cl
80105622:	74 ec                	je     80105610 <memcmp+0x20>
      return *s1 - *s2;
80105624:	0f b6 c1             	movzbl %cl,%eax
80105627:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105629:	5b                   	pop    %ebx
8010562a:	5e                   	pop    %esi
8010562b:	5d                   	pop    %ebp
8010562c:	c3                   	ret    
8010562d:	8d 76 00             	lea    0x0(%esi),%esi
80105630:	5b                   	pop    %ebx
  return 0;
80105631:	31 c0                	xor    %eax,%eax
}
80105633:	5e                   	pop    %esi
80105634:	5d                   	pop    %ebp
80105635:	c3                   	ret    
80105636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563d:	8d 76 00             	lea    0x0(%esi),%esi

80105640 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	57                   	push   %edi
80105648:	8b 55 08             	mov    0x8(%ebp),%edx
8010564b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010564e:	56                   	push   %esi
8010564f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105652:	39 d6                	cmp    %edx,%esi
80105654:	73 2a                	jae    80105680 <memmove+0x40>
80105656:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105659:	39 fa                	cmp    %edi,%edx
8010565b:	73 23                	jae    80105680 <memmove+0x40>
8010565d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105660:	85 c9                	test   %ecx,%ecx
80105662:	74 13                	je     80105677 <memmove+0x37>
80105664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105668:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010566c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010566f:	83 e8 01             	sub    $0x1,%eax
80105672:	83 f8 ff             	cmp    $0xffffffff,%eax
80105675:	75 f1                	jne    80105668 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105677:	5e                   	pop    %esi
80105678:	89 d0                	mov    %edx,%eax
8010567a:	5f                   	pop    %edi
8010567b:	5d                   	pop    %ebp
8010567c:	c3                   	ret    
8010567d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105680:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105683:	89 d7                	mov    %edx,%edi
80105685:	85 c9                	test   %ecx,%ecx
80105687:	74 ee                	je     80105677 <memmove+0x37>
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105690:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105691:	39 f0                	cmp    %esi,%eax
80105693:	75 fb                	jne    80105690 <memmove+0x50>
}
80105695:	5e                   	pop    %esi
80105696:	89 d0                	mov    %edx,%eax
80105698:	5f                   	pop    %edi
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret    
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop

801056a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801056a0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801056a4:	eb 9a                	jmp    80105640 <memmove>
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi

801056b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	56                   	push   %esi
801056b8:	8b 75 10             	mov    0x10(%ebp),%esi
801056bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056be:	53                   	push   %ebx
801056bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801056c2:	85 f6                	test   %esi,%esi
801056c4:	74 32                	je     801056f8 <strncmp+0x48>
801056c6:	01 c6                	add    %eax,%esi
801056c8:	eb 14                	jmp    801056de <strncmp+0x2e>
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056d0:	38 da                	cmp    %bl,%dl
801056d2:	75 14                	jne    801056e8 <strncmp+0x38>
    n--, p++, q++;
801056d4:	83 c0 01             	add    $0x1,%eax
801056d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801056da:	39 f0                	cmp    %esi,%eax
801056dc:	74 1a                	je     801056f8 <strncmp+0x48>
801056de:	0f b6 11             	movzbl (%ecx),%edx
801056e1:	0f b6 18             	movzbl (%eax),%ebx
801056e4:	84 d2                	test   %dl,%dl
801056e6:	75 e8                	jne    801056d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801056e8:	0f b6 c2             	movzbl %dl,%eax
801056eb:	29 d8                	sub    %ebx,%eax
}
801056ed:	5b                   	pop    %ebx
801056ee:	5e                   	pop    %esi
801056ef:	5d                   	pop    %ebp
801056f0:	c3                   	ret    
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056f8:	5b                   	pop    %ebx
    return 0;
801056f9:	31 c0                	xor    %eax,%eax
}
801056fb:	5e                   	pop    %esi
801056fc:	5d                   	pop    %ebp
801056fd:	c3                   	ret    
801056fe:	66 90                	xchg   %ax,%ax

80105700 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	57                   	push   %edi
80105708:	56                   	push   %esi
80105709:	8b 75 08             	mov    0x8(%ebp),%esi
8010570c:	53                   	push   %ebx
8010570d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105710:	89 f2                	mov    %esi,%edx
80105712:	eb 1b                	jmp    8010572f <strncpy+0x2f>
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105718:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010571c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010571f:	83 c2 01             	add    $0x1,%edx
80105722:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105726:	89 f9                	mov    %edi,%ecx
80105728:	88 4a ff             	mov    %cl,-0x1(%edx)
8010572b:	84 c9                	test   %cl,%cl
8010572d:	74 09                	je     80105738 <strncpy+0x38>
8010572f:	89 c3                	mov    %eax,%ebx
80105731:	83 e8 01             	sub    $0x1,%eax
80105734:	85 db                	test   %ebx,%ebx
80105736:	7f e0                	jg     80105718 <strncpy+0x18>
    ;
  while(n-- > 0)
80105738:	89 d1                	mov    %edx,%ecx
8010573a:	85 c0                	test   %eax,%eax
8010573c:	7e 15                	jle    80105753 <strncpy+0x53>
8010573e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105740:	83 c1 01             	add    $0x1,%ecx
80105743:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105747:	89 c8                	mov    %ecx,%eax
80105749:	f7 d0                	not    %eax
8010574b:	01 d0                	add    %edx,%eax
8010574d:	01 d8                	add    %ebx,%eax
8010574f:	85 c0                	test   %eax,%eax
80105751:	7f ed                	jg     80105740 <strncpy+0x40>
  return os;
}
80105753:	5b                   	pop    %ebx
80105754:	89 f0                	mov    %esi,%eax
80105756:	5e                   	pop    %esi
80105757:	5f                   	pop    %edi
80105758:	5d                   	pop    %ebp
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105760 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	56                   	push   %esi
80105768:	8b 55 10             	mov    0x10(%ebp),%edx
8010576b:	8b 75 08             	mov    0x8(%ebp),%esi
8010576e:	53                   	push   %ebx
8010576f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105772:	85 d2                	test   %edx,%edx
80105774:	7e 21                	jle    80105797 <safestrcpy+0x37>
80105776:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010577a:	89 f2                	mov    %esi,%edx
8010577c:	eb 12                	jmp    80105790 <safestrcpy+0x30>
8010577e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105780:	0f b6 08             	movzbl (%eax),%ecx
80105783:	83 c0 01             	add    $0x1,%eax
80105786:	83 c2 01             	add    $0x1,%edx
80105789:	88 4a ff             	mov    %cl,-0x1(%edx)
8010578c:	84 c9                	test   %cl,%cl
8010578e:	74 04                	je     80105794 <safestrcpy+0x34>
80105790:	39 d8                	cmp    %ebx,%eax
80105792:	75 ec                	jne    80105780 <safestrcpy+0x20>
    ;
  *s = 0;
80105794:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105797:	89 f0                	mov    %esi,%eax
80105799:	5b                   	pop    %ebx
8010579a:	5e                   	pop    %esi
8010579b:	5d                   	pop    %ebp
8010579c:	c3                   	ret    
8010579d:	8d 76 00             	lea    0x0(%esi),%esi

801057a0 <strlen>:

int
strlen(const char *s)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801057a5:	31 c0                	xor    %eax,%eax
{
801057a7:	89 e5                	mov    %esp,%ebp
801057a9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801057ac:	80 3a 00             	cmpb   $0x0,(%edx)
801057af:	74 10                	je     801057c1 <strlen+0x21>
801057b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057b8:	83 c0 01             	add    $0x1,%eax
801057bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801057bf:	75 f7                	jne    801057b8 <strlen+0x18>
    ;
  return n;
}
801057c1:	5d                   	pop    %ebp
801057c2:	c3                   	ret    

801057c3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057c7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801057cb:	55                   	push   %ebp
  pushl %ebx
801057cc:	53                   	push   %ebx
  pushl %esi
801057cd:	56                   	push   %esi
  pushl %edi
801057ce:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057cf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057d1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801057d3:	5f                   	pop    %edi
  popl %esi
801057d4:	5e                   	pop    %esi
  popl %ebx
801057d5:	5b                   	pop    %ebx
  popl %ebp
801057d6:	5d                   	pop    %ebp
  ret
801057d7:	c3                   	ret    
801057d8:	66 90                	xchg   %ax,%ax
801057da:	66 90                	xchg   %ax,%ax
801057dc:	66 90                	xchg   %ax,%ax
801057de:	66 90                	xchg   %ax,%ax

801057e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	53                   	push   %ebx
801057e8:	83 ec 04             	sub    $0x4,%esp
801057eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801057ee:	e8 ed e1 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801057f3:	8b 00                	mov    (%eax),%eax
801057f5:	39 d8                	cmp    %ebx,%eax
801057f7:	76 17                	jbe    80105810 <fetchint+0x30>
801057f9:	8d 53 04             	lea    0x4(%ebx),%edx
801057fc:	39 d0                	cmp    %edx,%eax
801057fe:	72 10                	jb     80105810 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105800:	8b 45 0c             	mov    0xc(%ebp),%eax
80105803:	8b 13                	mov    (%ebx),%edx
80105805:	89 10                	mov    %edx,(%eax)
  return 0;
80105807:	31 c0                	xor    %eax,%eax
}
80105809:	83 c4 04             	add    $0x4,%esp
8010580c:	5b                   	pop    %ebx
8010580d:	5d                   	pop    %ebp
8010580e:	c3                   	ret    
8010580f:	90                   	nop
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105815:	eb f2                	jmp    80105809 <fetchint+0x29>
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	53                   	push   %ebx
80105828:	83 ec 04             	sub    $0x4,%esp
8010582b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010582e:	e8 ad e1 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz)
80105833:	39 18                	cmp    %ebx,(%eax)
80105835:	76 31                	jbe    80105868 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105837:	8b 55 0c             	mov    0xc(%ebp),%edx
8010583a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010583c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010583e:	39 d3                	cmp    %edx,%ebx
80105840:	73 26                	jae    80105868 <fetchstr+0x48>
80105842:	89 d8                	mov    %ebx,%eax
80105844:	eb 11                	jmp    80105857 <fetchstr+0x37>
80105846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
80105850:	83 c0 01             	add    $0x1,%eax
80105853:	39 c2                	cmp    %eax,%edx
80105855:	76 11                	jbe    80105868 <fetchstr+0x48>
    if(*s == 0)
80105857:	80 38 00             	cmpb   $0x0,(%eax)
8010585a:	75 f4                	jne    80105850 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010585c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010585f:	29 d8                	sub    %ebx,%eax
}
80105861:	5b                   	pop    %ebx
80105862:	5d                   	pop    %ebp
80105863:	c3                   	ret    
80105864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105868:	83 c4 04             	add    $0x4,%esp
    return -1;
8010586b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105870:	5b                   	pop    %ebx
80105871:	5d                   	pop    %ebp
80105872:	c3                   	ret    
80105873:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	56                   	push   %esi
80105888:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105889:	e8 52 e1 ff ff       	call   801039e0 <myproc>
8010588e:	8b 55 08             	mov    0x8(%ebp),%edx
80105891:	8b 40 18             	mov    0x18(%eax),%eax
80105894:	8b 40 44             	mov    0x44(%eax),%eax
80105897:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010589a:	e8 41 e1 ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010589f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801058a2:	8b 00                	mov    (%eax),%eax
801058a4:	39 c6                	cmp    %eax,%esi
801058a6:	73 18                	jae    801058c0 <argint+0x40>
801058a8:	8d 53 08             	lea    0x8(%ebx),%edx
801058ab:	39 d0                	cmp    %edx,%eax
801058ad:	72 11                	jb     801058c0 <argint+0x40>
  *ip = *(int*)(addr);
801058af:	8b 45 0c             	mov    0xc(%ebp),%eax
801058b2:	8b 53 04             	mov    0x4(%ebx),%edx
801058b5:	89 10                	mov    %edx,(%eax)
  return 0;
801058b7:	31 c0                	xor    %eax,%eax
}
801058b9:	5b                   	pop    %ebx
801058ba:	5e                   	pop    %esi
801058bb:	5d                   	pop    %ebp
801058bc:	c3                   	ret    
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801058c5:	eb f2                	jmp    801058b9 <argint+0x39>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	56                   	push   %esi
801058d8:	53                   	push   %ebx
801058d9:	83 ec 10             	sub    $0x10,%esp
801058dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801058df:	e8 fc e0 ff ff       	call   801039e0 <myproc>
 
  if(argint(n, &i) < 0)
801058e4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801058e7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801058e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ec:	50                   	push   %eax
801058ed:	ff 75 08             	pushl  0x8(%ebp)
801058f0:	e8 8b ff ff ff       	call   80105880 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	78 24                	js     80105920 <argptr+0x50>
801058fc:	85 db                	test   %ebx,%ebx
801058fe:	78 20                	js     80105920 <argptr+0x50>
80105900:	8b 16                	mov    (%esi),%edx
80105902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105905:	39 c2                	cmp    %eax,%edx
80105907:	76 17                	jbe    80105920 <argptr+0x50>
80105909:	01 c3                	add    %eax,%ebx
8010590b:	39 da                	cmp    %ebx,%edx
8010590d:	72 11                	jb     80105920 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010590f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105912:	89 02                	mov    %eax,(%edx)
  return 0;
80105914:	31 c0                	xor    %eax,%eax
}
80105916:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105919:	5b                   	pop    %ebx
8010591a:	5e                   	pop    %esi
8010591b:	5d                   	pop    %ebp
8010591c:	c3                   	ret    
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105925:	eb ef                	jmp    80105916 <argptr+0x46>
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105930:	f3 0f 1e fb          	endbr32 
80105934:	55                   	push   %ebp
80105935:	89 e5                	mov    %esp,%ebp
80105937:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010593a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593d:	50                   	push   %eax
8010593e:	ff 75 08             	pushl  0x8(%ebp)
80105941:	e8 3a ff ff ff       	call   80105880 <argint>
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	85 c0                	test   %eax,%eax
8010594b:	78 13                	js     80105960 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010594d:	83 ec 08             	sub    $0x8,%esp
80105950:	ff 75 0c             	pushl  0xc(%ebp)
80105953:	ff 75 f4             	pushl  -0xc(%ebp)
80105956:	e8 c5 fe ff ff       	call   80105820 <fetchstr>
8010595b:	83 c4 10             	add    $0x10,%esp
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    
80105960:	c9                   	leave  
    return -1;
80105961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105966:	c3                   	ret    
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax

80105970 <syscall>:

};

void
syscall(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	53                   	push   %ebx
80105978:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010597b:	e8 60 e0 ff ff       	call   801039e0 <myproc>
80105980:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105982:	8b 40 18             	mov    0x18(%eax),%eax
80105985:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105988:	8d 50 ff             	lea    -0x1(%eax),%edx
8010598b:	83 fa 1d             	cmp    $0x1d,%edx
8010598e:	77 20                	ja     801059b0 <syscall+0x40>
80105990:	8b 14 85 40 8b 10 80 	mov    -0x7fef74c0(,%eax,4),%edx
80105997:	85 d2                	test   %edx,%edx
80105999:	74 15                	je     801059b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010599b:	ff d2                	call   *%edx
8010599d:	89 c2                	mov    %eax,%edx
8010599f:	8b 43 18             	mov    0x18(%ebx),%eax
801059a2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801059a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801059b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801059b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801059b4:	50                   	push   %eax
801059b5:	ff 73 10             	pushl  0x10(%ebx)
801059b8:	68 09 8b 10 80       	push   $0x80108b09
801059bd:	e8 ee ac ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801059c2:	8b 43 18             	mov    0x18(%ebx),%eax
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801059cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d2:	c9                   	leave  
801059d3:	c3                   	ret    
801059d4:	66 90                	xchg   %ax,%ax
801059d6:	66 90                	xchg   %ax,%ax
801059d8:	66 90                	xchg   %ax,%ax
801059da:	66 90                	xchg   %ax,%ax
801059dc:	66 90                	xchg   %ax,%ax
801059de:	66 90                	xchg   %ax,%ax

801059e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801059e8:	53                   	push   %ebx
801059e9:	83 ec 34             	sub    $0x34,%esp
801059ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801059ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801059f2:	57                   	push   %edi
801059f3:	50                   	push   %eax
{
801059f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801059f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801059fa:	e8 61 c6 ff ff       	call   80102060 <nameiparent>
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	85 c0                	test   %eax,%eax
80105a04:	0f 84 46 01 00 00    	je     80105b50 <create+0x170>
    return 0;
  ilock(dp);
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	89 c3                	mov    %eax,%ebx
80105a0f:	50                   	push   %eax
80105a10:	e8 5b bd ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a15:	83 c4 0c             	add    $0xc,%esp
80105a18:	6a 00                	push   $0x0
80105a1a:	57                   	push   %edi
80105a1b:	53                   	push   %ebx
80105a1c:	e8 9f c2 ff ff       	call   80101cc0 <dirlookup>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	89 c6                	mov    %eax,%esi
80105a26:	85 c0                	test   %eax,%eax
80105a28:	74 56                	je     80105a80 <create+0xa0>
    iunlockput(dp);
80105a2a:	83 ec 0c             	sub    $0xc,%esp
80105a2d:	53                   	push   %ebx
80105a2e:	e8 dd bf ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105a33:	89 34 24             	mov    %esi,(%esp)
80105a36:	e8 35 bd ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a3b:	83 c4 10             	add    $0x10,%esp
80105a3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a43:	75 1b                	jne    80105a60 <create+0x80>
80105a45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105a4a:	75 14                	jne    80105a60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a4f:	89 f0                	mov    %esi,%eax
80105a51:	5b                   	pop    %ebx
80105a52:	5e                   	pop    %esi
80105a53:	5f                   	pop    %edi
80105a54:	5d                   	pop    %ebp
80105a55:	c3                   	ret    
80105a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	56                   	push   %esi
    return 0;
80105a64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105a66:	e8 a5 bf ff ff       	call   80101a10 <iunlockput>
    return 0;
80105a6b:	83 c4 10             	add    $0x10,%esp
}
80105a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a71:	89 f0                	mov    %esi,%eax
80105a73:	5b                   	pop    %ebx
80105a74:	5e                   	pop    %esi
80105a75:	5f                   	pop    %edi
80105a76:	5d                   	pop    %ebp
80105a77:	c3                   	ret    
80105a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105a80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a84:	83 ec 08             	sub    $0x8,%esp
80105a87:	50                   	push   %eax
80105a88:	ff 33                	pushl  (%ebx)
80105a8a:	e8 61 bb ff ff       	call   801015f0 <ialloc>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	89 c6                	mov    %eax,%esi
80105a94:	85 c0                	test   %eax,%eax
80105a96:	0f 84 cd 00 00 00    	je     80105b69 <create+0x189>
  ilock(ip);
80105a9c:	83 ec 0c             	sub    $0xc,%esp
80105a9f:	50                   	push   %eax
80105aa0:	e8 cb bc ff ff       	call   80101770 <ilock>
  ip->major = major;
80105aa5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105aa9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105aad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105ab1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105ab5:	b8 01 00 00 00       	mov    $0x1,%eax
80105aba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105abe:	89 34 24             	mov    %esi,(%esp)
80105ac1:	e8 ea bb ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105ace:	74 30                	je     80105b00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105ad0:	83 ec 04             	sub    $0x4,%esp
80105ad3:	ff 76 04             	pushl  0x4(%esi)
80105ad6:	57                   	push   %edi
80105ad7:	53                   	push   %ebx
80105ad8:	e8 a3 c4 ff ff       	call   80101f80 <dirlink>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	78 78                	js     80105b5c <create+0x17c>
  iunlockput(dp);
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	53                   	push   %ebx
80105ae8:	e8 23 bf ff ff       	call   80101a10 <iunlockput>
  return ip;
80105aed:	83 c4 10             	add    $0x10,%esp
}
80105af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af3:	89 f0                	mov    %esi,%eax
80105af5:	5b                   	pop    %ebx
80105af6:	5e                   	pop    %esi
80105af7:	5f                   	pop    %edi
80105af8:	5d                   	pop    %ebp
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105b00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105b03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105b08:	53                   	push   %ebx
80105b09:	e8 a2 bb ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b0e:	83 c4 0c             	add    $0xc,%esp
80105b11:	ff 76 04             	pushl  0x4(%esi)
80105b14:	68 d8 8b 10 80       	push   $0x80108bd8
80105b19:	56                   	push   %esi
80105b1a:	e8 61 c4 ff ff       	call   80101f80 <dirlink>
80105b1f:	83 c4 10             	add    $0x10,%esp
80105b22:	85 c0                	test   %eax,%eax
80105b24:	78 18                	js     80105b3e <create+0x15e>
80105b26:	83 ec 04             	sub    $0x4,%esp
80105b29:	ff 73 04             	pushl  0x4(%ebx)
80105b2c:	68 d7 8b 10 80       	push   $0x80108bd7
80105b31:	56                   	push   %esi
80105b32:	e8 49 c4 ff ff       	call   80101f80 <dirlink>
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	79 92                	jns    80105ad0 <create+0xf0>
      panic("create dots");
80105b3e:	83 ec 0c             	sub    $0xc,%esp
80105b41:	68 cb 8b 10 80       	push   $0x80108bcb
80105b46:	e8 45 a8 ff ff       	call   80100390 <panic>
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop
}
80105b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105b53:	31 f6                	xor    %esi,%esi
}
80105b55:	5b                   	pop    %ebx
80105b56:	89 f0                	mov    %esi,%eax
80105b58:	5e                   	pop    %esi
80105b59:	5f                   	pop    %edi
80105b5a:	5d                   	pop    %ebp
80105b5b:	c3                   	ret    
    panic("create: dirlink");
80105b5c:	83 ec 0c             	sub    $0xc,%esp
80105b5f:	68 da 8b 10 80       	push   $0x80108bda
80105b64:	e8 27 a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	68 bc 8b 10 80       	push   $0x80108bbc
80105b71:	e8 1a a8 ff ff       	call   80100390 <panic>
80105b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi

80105b80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	56                   	push   %esi
80105b84:	89 d6                	mov    %edx,%esi
80105b86:	53                   	push   %ebx
80105b87:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105b8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105b8f:	50                   	push   %eax
80105b90:	6a 00                	push   $0x0
80105b92:	e8 e9 fc ff ff       	call   80105880 <argint>
80105b97:	83 c4 10             	add    $0x10,%esp
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	78 2a                	js     80105bc8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105ba2:	77 24                	ja     80105bc8 <argfd.constprop.0+0x48>
80105ba4:	e8 37 de ff ff       	call   801039e0 <myproc>
80105ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105bb0:	85 c0                	test   %eax,%eax
80105bb2:	74 14                	je     80105bc8 <argfd.constprop.0+0x48>
  if(pfd)
80105bb4:	85 db                	test   %ebx,%ebx
80105bb6:	74 02                	je     80105bba <argfd.constprop.0+0x3a>
    *pfd = fd;
80105bb8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105bba:	89 06                	mov    %eax,(%esi)
  return 0;
80105bbc:	31 c0                	xor    %eax,%eax
}
80105bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bc1:	5b                   	pop    %ebx
80105bc2:	5e                   	pop    %esi
80105bc3:	5d                   	pop    %ebp
80105bc4:	c3                   	ret    
80105bc5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcd:	eb ef                	jmp    80105bbe <argfd.constprop.0+0x3e>
80105bcf:	90                   	nop

80105bd0 <sys_dup>:
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105bd5:	31 c0                	xor    %eax,%eax
{
80105bd7:	89 e5                	mov    %esp,%ebp
80105bd9:	56                   	push   %esi
80105bda:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105bdb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105bde:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105be1:	e8 9a ff ff ff       	call   80105b80 <argfd.constprop.0>
80105be6:	85 c0                	test   %eax,%eax
80105be8:	78 1e                	js     80105c08 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105bea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105bed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105bef:	e8 ec dd ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bf8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bfc:	85 d2                	test   %edx,%edx
80105bfe:	74 20                	je     80105c20 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105c00:	83 c3 01             	add    $0x1,%ebx
80105c03:	83 fb 10             	cmp    $0x10,%ebx
80105c06:	75 f0                	jne    80105bf8 <sys_dup+0x28>
}
80105c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105c0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105c10:	89 d8                	mov    %ebx,%eax
80105c12:	5b                   	pop    %ebx
80105c13:	5e                   	pop    %esi
80105c14:	5d                   	pop    %ebp
80105c15:	c3                   	ret    
80105c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105c20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105c24:	83 ec 0c             	sub    $0xc,%esp
80105c27:	ff 75 f4             	pushl  -0xc(%ebp)
80105c2a:	e8 51 b2 ff ff       	call   80100e80 <filedup>
  return fd;
80105c2f:	83 c4 10             	add    $0x10,%esp
}
80105c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c35:	89 d8                	mov    %ebx,%eax
80105c37:	5b                   	pop    %ebx
80105c38:	5e                   	pop    %esi
80105c39:	5d                   	pop    %ebp
80105c3a:	c3                   	ret    
80105c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop

80105c40 <sys_read>:
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c45:	31 c0                	xor    %eax,%eax
{
80105c47:	89 e5                	mov    %esp,%ebp
80105c49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105c4f:	e8 2c ff ff ff       	call   80105b80 <argfd.constprop.0>
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 48                	js     80105ca0 <sys_read+0x60>
80105c58:	83 ec 08             	sub    $0x8,%esp
80105c5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	6a 02                	push   $0x2
80105c61:	e8 1a fc ff ff       	call   80105880 <argint>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	78 33                	js     80105ca0 <sys_read+0x60>
80105c6d:	83 ec 04             	sub    $0x4,%esp
80105c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c73:	ff 75 f0             	pushl  -0x10(%ebp)
80105c76:	50                   	push   %eax
80105c77:	6a 01                	push   $0x1
80105c79:	e8 52 fc ff ff       	call   801058d0 <argptr>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	85 c0                	test   %eax,%eax
80105c83:	78 1b                	js     80105ca0 <sys_read+0x60>
  return fileread(f, p, n);
80105c85:	83 ec 04             	sub    $0x4,%esp
80105c88:	ff 75 f0             	pushl  -0x10(%ebp)
80105c8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c8e:	ff 75 ec             	pushl  -0x14(%ebp)
80105c91:	e8 6a b3 ff ff       	call   80101000 <fileread>
80105c96:	83 c4 10             	add    $0x10,%esp
}
80105c99:	c9                   	leave  
80105c9a:	c3                   	ret    
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
80105ca0:	c9                   	leave  
    return -1;
80105ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca6:	c3                   	ret    
80105ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <sys_write>:
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cb5:	31 c0                	xor    %eax,%eax
{
80105cb7:	89 e5                	mov    %esp,%ebp
80105cb9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cbc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105cbf:	e8 bc fe ff ff       	call   80105b80 <argfd.constprop.0>
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 48                	js     80105d10 <sys_write+0x60>
80105cc8:	83 ec 08             	sub    $0x8,%esp
80105ccb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cce:	50                   	push   %eax
80105ccf:	6a 02                	push   $0x2
80105cd1:	e8 aa fb ff ff       	call   80105880 <argint>
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	78 33                	js     80105d10 <sys_write+0x60>
80105cdd:	83 ec 04             	sub    $0x4,%esp
80105ce0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ce6:	50                   	push   %eax
80105ce7:	6a 01                	push   $0x1
80105ce9:	e8 e2 fb ff ff       	call   801058d0 <argptr>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	78 1b                	js     80105d10 <sys_write+0x60>
  return filewrite(f, p, n);
80105cf5:	83 ec 04             	sub    $0x4,%esp
80105cf8:	ff 75 f0             	pushl  -0x10(%ebp)
80105cfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfe:	ff 75 ec             	pushl  -0x14(%ebp)
80105d01:	e8 9a b3 ff ff       	call   801010a0 <filewrite>
80105d06:	83 c4 10             	add    $0x10,%esp
}
80105d09:	c9                   	leave  
80105d0a:	c3                   	ret    
80105d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
80105d10:	c9                   	leave  
    return -1;
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d16:	c3                   	ret    
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <sys_close>:
{
80105d20:	f3 0f 1e fb          	endbr32 
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105d2a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105d2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d30:	e8 4b fe ff ff       	call   80105b80 <argfd.constprop.0>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 27                	js     80105d60 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105d39:	e8 a2 dc ff ff       	call   801039e0 <myproc>
80105d3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105d41:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105d44:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105d4b:	00 
  fileclose(f);
80105d4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4f:	e8 7c b1 ff ff       	call   80100ed0 <fileclose>
  return 0;
80105d54:	83 c4 10             	add    $0x10,%esp
80105d57:	31 c0                	xor    %eax,%eax
}
80105d59:	c9                   	leave  
80105d5a:	c3                   	ret    
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
80105d60:	c9                   	leave  
    return -1;
80105d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <sys_fstat>:
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d75:	31 c0                	xor    %eax,%eax
{
80105d77:	89 e5                	mov    %esp,%ebp
80105d79:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d7c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105d7f:	e8 fc fd ff ff       	call   80105b80 <argfd.constprop.0>
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 30                	js     80105db8 <sys_fstat+0x48>
80105d88:	83 ec 04             	sub    $0x4,%esp
80105d8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d8e:	6a 14                	push   $0x14
80105d90:	50                   	push   %eax
80105d91:	6a 01                	push   $0x1
80105d93:	e8 38 fb ff ff       	call   801058d0 <argptr>
80105d98:	83 c4 10             	add    $0x10,%esp
80105d9b:	85 c0                	test   %eax,%eax
80105d9d:	78 19                	js     80105db8 <sys_fstat+0x48>
  return filestat(f, st);
80105d9f:	83 ec 08             	sub    $0x8,%esp
80105da2:	ff 75 f4             	pushl  -0xc(%ebp)
80105da5:	ff 75 f0             	pushl  -0x10(%ebp)
80105da8:	e8 03 b2 ff ff       	call   80100fb0 <filestat>
80105dad:	83 c4 10             	add    $0x10,%esp
}
80105db0:	c9                   	leave  
80105db1:	c3                   	ret    
80105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105db8:	c9                   	leave  
    return -1;
80105db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dbe:	c3                   	ret    
80105dbf:	90                   	nop

80105dc0 <sys_link>:
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	57                   	push   %edi
80105dc8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105dc9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105dcc:	53                   	push   %ebx
80105dcd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105dd0:	50                   	push   %eax
80105dd1:	6a 00                	push   $0x0
80105dd3:	e8 58 fb ff ff       	call   80105930 <argstr>
80105dd8:	83 c4 10             	add    $0x10,%esp
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	0f 88 ff 00 00 00    	js     80105ee2 <sys_link+0x122>
80105de3:	83 ec 08             	sub    $0x8,%esp
80105de6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 01                	push   $0x1
80105dec:	e8 3f fb ff ff       	call   80105930 <argstr>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	0f 88 e6 00 00 00    	js     80105ee2 <sys_link+0x122>
  begin_op();
80105dfc:	e8 3f cf ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80105e01:	83 ec 0c             	sub    $0xc,%esp
80105e04:	ff 75 d4             	pushl  -0x2c(%ebp)
80105e07:	e8 34 c2 ff ff       	call   80102040 <namei>
80105e0c:	83 c4 10             	add    $0x10,%esp
80105e0f:	89 c3                	mov    %eax,%ebx
80105e11:	85 c0                	test   %eax,%eax
80105e13:	0f 84 e8 00 00 00    	je     80105f01 <sys_link+0x141>
  ilock(ip);
80105e19:	83 ec 0c             	sub    $0xc,%esp
80105e1c:	50                   	push   %eax
80105e1d:	e8 4e b9 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e2a:	0f 84 b9 00 00 00    	je     80105ee9 <sys_link+0x129>
  iupdate(ip);
80105e30:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105e33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105e38:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105e3b:	53                   	push   %ebx
80105e3c:	e8 6f b8 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105e41:	89 1c 24             	mov    %ebx,(%esp)
80105e44:	e8 07 ba ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105e49:	58                   	pop    %eax
80105e4a:	5a                   	pop    %edx
80105e4b:	57                   	push   %edi
80105e4c:	ff 75 d0             	pushl  -0x30(%ebp)
80105e4f:	e8 0c c2 ff ff       	call   80102060 <nameiparent>
80105e54:	83 c4 10             	add    $0x10,%esp
80105e57:	89 c6                	mov    %eax,%esi
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 5f                	je     80105ebc <sys_link+0xfc>
  ilock(dp);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	50                   	push   %eax
80105e61:	e8 0a b9 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e66:	8b 03                	mov    (%ebx),%eax
80105e68:	83 c4 10             	add    $0x10,%esp
80105e6b:	39 06                	cmp    %eax,(%esi)
80105e6d:	75 41                	jne    80105eb0 <sys_link+0xf0>
80105e6f:	83 ec 04             	sub    $0x4,%esp
80105e72:	ff 73 04             	pushl  0x4(%ebx)
80105e75:	57                   	push   %edi
80105e76:	56                   	push   %esi
80105e77:	e8 04 c1 ff ff       	call   80101f80 <dirlink>
80105e7c:	83 c4 10             	add    $0x10,%esp
80105e7f:	85 c0                	test   %eax,%eax
80105e81:	78 2d                	js     80105eb0 <sys_link+0xf0>
  iunlockput(dp);
80105e83:	83 ec 0c             	sub    $0xc,%esp
80105e86:	56                   	push   %esi
80105e87:	e8 84 bb ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105e8c:	89 1c 24             	mov    %ebx,(%esp)
80105e8f:	e8 0c ba ff ff       	call   801018a0 <iput>
  end_op();
80105e94:	e8 17 cf ff ff       	call   80102db0 <end_op>
  return 0;
80105e99:	83 c4 10             	add    $0x10,%esp
80105e9c:	31 c0                	xor    %eax,%eax
}
80105e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea1:	5b                   	pop    %ebx
80105ea2:	5e                   	pop    %esi
80105ea3:	5f                   	pop    %edi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret    
80105ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	56                   	push   %esi
80105eb4:	e8 57 bb ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105eb9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ebc:	83 ec 0c             	sub    $0xc,%esp
80105ebf:	53                   	push   %ebx
80105ec0:	e8 ab b8 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105ec5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105eca:	89 1c 24             	mov    %ebx,(%esp)
80105ecd:	e8 de b7 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105ed2:	89 1c 24             	mov    %ebx,(%esp)
80105ed5:	e8 36 bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105eda:	e8 d1 ce ff ff       	call   80102db0 <end_op>
  return -1;
80105edf:	83 c4 10             	add    $0x10,%esp
80105ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee7:	eb b5                	jmp    80105e9e <sys_link+0xde>
    iunlockput(ip);
80105ee9:	83 ec 0c             	sub    $0xc,%esp
80105eec:	53                   	push   %ebx
80105eed:	e8 1e bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105ef2:	e8 b9 ce ff ff       	call   80102db0 <end_op>
    return -1;
80105ef7:	83 c4 10             	add    $0x10,%esp
80105efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eff:	eb 9d                	jmp    80105e9e <sys_link+0xde>
    end_op();
80105f01:	e8 aa ce ff ff       	call   80102db0 <end_op>
    return -1;
80105f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0b:	eb 91                	jmp    80105e9e <sys_link+0xde>
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi

80105f10 <sys_unlink>:
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	57                   	push   %edi
80105f18:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105f19:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105f1c:	53                   	push   %ebx
80105f1d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105f20:	50                   	push   %eax
80105f21:	6a 00                	push   $0x0
80105f23:	e8 08 fa ff ff       	call   80105930 <argstr>
80105f28:	83 c4 10             	add    $0x10,%esp
80105f2b:	85 c0                	test   %eax,%eax
80105f2d:	0f 88 7d 01 00 00    	js     801060b0 <sys_unlink+0x1a0>
  begin_op();
80105f33:	e8 08 ce ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f38:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105f3b:	83 ec 08             	sub    $0x8,%esp
80105f3e:	53                   	push   %ebx
80105f3f:	ff 75 c0             	pushl  -0x40(%ebp)
80105f42:	e8 19 c1 ff ff       	call   80102060 <nameiparent>
80105f47:	83 c4 10             	add    $0x10,%esp
80105f4a:	89 c6                	mov    %eax,%esi
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	0f 84 66 01 00 00    	je     801060ba <sys_unlink+0x1aa>
  ilock(dp);
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	50                   	push   %eax
80105f58:	e8 13 b8 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f5d:	58                   	pop    %eax
80105f5e:	5a                   	pop    %edx
80105f5f:	68 d8 8b 10 80       	push   $0x80108bd8
80105f64:	53                   	push   %ebx
80105f65:	e8 36 bd ff ff       	call   80101ca0 <namecmp>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	0f 84 03 01 00 00    	je     80106078 <sys_unlink+0x168>
80105f75:	83 ec 08             	sub    $0x8,%esp
80105f78:	68 d7 8b 10 80       	push   $0x80108bd7
80105f7d:	53                   	push   %ebx
80105f7e:	e8 1d bd ff ff       	call   80101ca0 <namecmp>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	85 c0                	test   %eax,%eax
80105f88:	0f 84 ea 00 00 00    	je     80106078 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105f8e:	83 ec 04             	sub    $0x4,%esp
80105f91:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105f94:	50                   	push   %eax
80105f95:	53                   	push   %ebx
80105f96:	56                   	push   %esi
80105f97:	e8 24 bd ff ff       	call   80101cc0 <dirlookup>
80105f9c:	83 c4 10             	add    $0x10,%esp
80105f9f:	89 c3                	mov    %eax,%ebx
80105fa1:	85 c0                	test   %eax,%eax
80105fa3:	0f 84 cf 00 00 00    	je     80106078 <sys_unlink+0x168>
  ilock(ip);
80105fa9:	83 ec 0c             	sub    $0xc,%esp
80105fac:	50                   	push   %eax
80105fad:	e8 be b7 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105fba:	0f 8e 23 01 00 00    	jle    801060e3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105fc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105fc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105fc8:	74 66                	je     80106030 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105fca:	83 ec 04             	sub    $0x4,%esp
80105fcd:	6a 10                	push   $0x10
80105fcf:	6a 00                	push   $0x0
80105fd1:	57                   	push   %edi
80105fd2:	e8 c9 f5 ff ff       	call   801055a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fd7:	6a 10                	push   $0x10
80105fd9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105fdc:	57                   	push   %edi
80105fdd:	56                   	push   %esi
80105fde:	e8 8d bb ff ff       	call   80101b70 <writei>
80105fe3:	83 c4 20             	add    $0x20,%esp
80105fe6:	83 f8 10             	cmp    $0x10,%eax
80105fe9:	0f 85 e7 00 00 00    	jne    801060d6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105fef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ff4:	0f 84 96 00 00 00    	je     80106090 <sys_unlink+0x180>
  iunlockput(dp);
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	56                   	push   %esi
80105ffe:	e8 0d ba ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80106003:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106008:	89 1c 24             	mov    %ebx,(%esp)
8010600b:	e8 a0 b6 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80106010:	89 1c 24             	mov    %ebx,(%esp)
80106013:	e8 f8 b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106018:	e8 93 cd ff ff       	call   80102db0 <end_op>
  return 0;
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	31 c0                	xor    %eax,%eax
}
80106022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106025:	5b                   	pop    %ebx
80106026:	5e                   	pop    %esi
80106027:	5f                   	pop    %edi
80106028:	5d                   	pop    %ebp
80106029:	c3                   	ret    
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106030:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106034:	76 94                	jbe    80105fca <sys_unlink+0xba>
80106036:	ba 20 00 00 00       	mov    $0x20,%edx
8010603b:	eb 0b                	jmp    80106048 <sys_unlink+0x138>
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
80106040:	83 c2 10             	add    $0x10,%edx
80106043:	39 53 58             	cmp    %edx,0x58(%ebx)
80106046:	76 82                	jbe    80105fca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106048:	6a 10                	push   $0x10
8010604a:	52                   	push   %edx
8010604b:	57                   	push   %edi
8010604c:	53                   	push   %ebx
8010604d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106050:	e8 1b ba ff ff       	call   80101a70 <readi>
80106055:	83 c4 10             	add    $0x10,%esp
80106058:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010605b:	83 f8 10             	cmp    $0x10,%eax
8010605e:	75 69                	jne    801060c9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80106060:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106065:	74 d9                	je     80106040 <sys_unlink+0x130>
    iunlockput(ip);
80106067:	83 ec 0c             	sub    $0xc,%esp
8010606a:	53                   	push   %ebx
8010606b:	e8 a0 b9 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106077:	90                   	nop
  iunlockput(dp);
80106078:	83 ec 0c             	sub    $0xc,%esp
8010607b:	56                   	push   %esi
8010607c:	e8 8f b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106081:	e8 2a cd ff ff       	call   80102db0 <end_op>
  return -1;
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608e:	eb 92                	jmp    80106022 <sys_unlink+0x112>
    iupdate(dp);
80106090:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106093:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106098:	56                   	push   %esi
80106099:	e8 12 b6 ff ff       	call   801016b0 <iupdate>
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	e9 54 ff ff ff       	jmp    80105ffa <sys_unlink+0xea>
801060a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b5:	e9 68 ff ff ff       	jmp    80106022 <sys_unlink+0x112>
    end_op();
801060ba:	e8 f1 cc ff ff       	call   80102db0 <end_op>
    return -1;
801060bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c4:	e9 59 ff ff ff       	jmp    80106022 <sys_unlink+0x112>
      panic("isdirempty: readi");
801060c9:	83 ec 0c             	sub    $0xc,%esp
801060cc:	68 fc 8b 10 80       	push   $0x80108bfc
801060d1:	e8 ba a2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801060d6:	83 ec 0c             	sub    $0xc,%esp
801060d9:	68 0e 8c 10 80       	push   $0x80108c0e
801060de:	e8 ad a2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	68 ea 8b 10 80       	push   $0x80108bea
801060eb:	e8 a0 a2 ff ff       	call   80100390 <panic>

801060f0 <sys_open>:

int
sys_open(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	57                   	push   %edi
801060f8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801060fc:	53                   	push   %ebx
801060fd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106100:	50                   	push   %eax
80106101:	6a 00                	push   $0x0
80106103:	e8 28 f8 ff ff       	call   80105930 <argstr>
80106108:	83 c4 10             	add    $0x10,%esp
8010610b:	85 c0                	test   %eax,%eax
8010610d:	0f 88 8a 00 00 00    	js     8010619d <sys_open+0xad>
80106113:	83 ec 08             	sub    $0x8,%esp
80106116:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106119:	50                   	push   %eax
8010611a:	6a 01                	push   $0x1
8010611c:	e8 5f f7 ff ff       	call   80105880 <argint>
80106121:	83 c4 10             	add    $0x10,%esp
80106124:	85 c0                	test   %eax,%eax
80106126:	78 75                	js     8010619d <sys_open+0xad>
    return -1;

  begin_op();
80106128:	e8 13 cc ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010612d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106131:	75 75                	jne    801061a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106133:	83 ec 0c             	sub    $0xc,%esp
80106136:	ff 75 e0             	pushl  -0x20(%ebp)
80106139:	e8 02 bf ff ff       	call   80102040 <namei>
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	89 c6                	mov    %eax,%esi
80106143:	85 c0                	test   %eax,%eax
80106145:	74 7e                	je     801061c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106147:	83 ec 0c             	sub    $0xc,%esp
8010614a:	50                   	push   %eax
8010614b:	e8 20 b6 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106150:	83 c4 10             	add    $0x10,%esp
80106153:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106158:	0f 84 c2 00 00 00    	je     80106220 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010615e:	e8 ad ac ff ff       	call   80100e10 <filealloc>
80106163:	89 c7                	mov    %eax,%edi
80106165:	85 c0                	test   %eax,%eax
80106167:	74 23                	je     8010618c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106169:	e8 72 d8 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010616e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106170:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106174:	85 d2                	test   %edx,%edx
80106176:	74 60                	je     801061d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106178:	83 c3 01             	add    $0x1,%ebx
8010617b:	83 fb 10             	cmp    $0x10,%ebx
8010617e:	75 f0                	jne    80106170 <sys_open+0x80>
    if(f)
      fileclose(f);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	57                   	push   %edi
80106184:	e8 47 ad ff ff       	call   80100ed0 <fileclose>
80106189:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010618c:	83 ec 0c             	sub    $0xc,%esp
8010618f:	56                   	push   %esi
80106190:	e8 7b b8 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106195:	e8 16 cc ff ff       	call   80102db0 <end_op>
    return -1;
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a2:	eb 6d                	jmp    80106211 <sys_open+0x121>
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801061ae:	31 c9                	xor    %ecx,%ecx
801061b0:	ba 02 00 00 00       	mov    $0x2,%edx
801061b5:	6a 00                	push   $0x0
801061b7:	e8 24 f8 ff ff       	call   801059e0 <create>
    if(ip == 0){
801061bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801061bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801061c1:	85 c0                	test   %eax,%eax
801061c3:	75 99                	jne    8010615e <sys_open+0x6e>
      end_op();
801061c5:	e8 e6 cb ff ff       	call   80102db0 <end_op>
      return -1;
801061ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061cf:	eb 40                	jmp    80106211 <sys_open+0x121>
801061d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801061d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801061db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801061df:	56                   	push   %esi
801061e0:	e8 6b b6 ff ff       	call   80101850 <iunlock>
  end_op();
801061e5:	e8 c6 cb ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
801061ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801061f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801061f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801061f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801061fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106202:	f7 d0                	not    %eax
80106204:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106207:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010620a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010620d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106211:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106214:	89 d8                	mov    %ebx,%eax
80106216:	5b                   	pop    %ebx
80106217:	5e                   	pop    %esi
80106218:	5f                   	pop    %edi
80106219:	5d                   	pop    %ebp
8010621a:	c3                   	ret    
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106220:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106223:	85 c9                	test   %ecx,%ecx
80106225:	0f 84 33 ff ff ff    	je     8010615e <sys_open+0x6e>
8010622b:	e9 5c ff ff ff       	jmp    8010618c <sys_open+0x9c>

80106230 <sys_mkdir>:

int
sys_mkdir(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010623a:	e8 01 cb ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010623f:	83 ec 08             	sub    $0x8,%esp
80106242:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106245:	50                   	push   %eax
80106246:	6a 00                	push   $0x0
80106248:	e8 e3 f6 ff ff       	call   80105930 <argstr>
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	85 c0                	test   %eax,%eax
80106252:	78 34                	js     80106288 <sys_mkdir+0x58>
80106254:	83 ec 0c             	sub    $0xc,%esp
80106257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625a:	31 c9                	xor    %ecx,%ecx
8010625c:	ba 01 00 00 00       	mov    $0x1,%edx
80106261:	6a 00                	push   $0x0
80106263:	e8 78 f7 ff ff       	call   801059e0 <create>
80106268:	83 c4 10             	add    $0x10,%esp
8010626b:	85 c0                	test   %eax,%eax
8010626d:	74 19                	je     80106288 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010626f:	83 ec 0c             	sub    $0xc,%esp
80106272:	50                   	push   %eax
80106273:	e8 98 b7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106278:	e8 33 cb ff ff       	call   80102db0 <end_op>
  return 0;
8010627d:	83 c4 10             	add    $0x10,%esp
80106280:	31 c0                	xor    %eax,%eax
}
80106282:	c9                   	leave  
80106283:	c3                   	ret    
80106284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106288:	e8 23 cb ff ff       	call   80102db0 <end_op>
    return -1;
8010628d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106292:	c9                   	leave  
80106293:	c3                   	ret    
80106294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010629b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010629f:	90                   	nop

801062a0 <sys_mknod>:

int
sys_mknod(void)
{
801062a0:	f3 0f 1e fb          	endbr32 
801062a4:	55                   	push   %ebp
801062a5:	89 e5                	mov    %esp,%ebp
801062a7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801062aa:	e8 91 ca ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801062af:	83 ec 08             	sub    $0x8,%esp
801062b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062b5:	50                   	push   %eax
801062b6:	6a 00                	push   $0x0
801062b8:	e8 73 f6 ff ff       	call   80105930 <argstr>
801062bd:	83 c4 10             	add    $0x10,%esp
801062c0:	85 c0                	test   %eax,%eax
801062c2:	78 64                	js     80106328 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801062c4:	83 ec 08             	sub    $0x8,%esp
801062c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ca:	50                   	push   %eax
801062cb:	6a 01                	push   $0x1
801062cd:	e8 ae f5 ff ff       	call   80105880 <argint>
  if((argstr(0, &path)) < 0 ||
801062d2:	83 c4 10             	add    $0x10,%esp
801062d5:	85 c0                	test   %eax,%eax
801062d7:	78 4f                	js     80106328 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801062d9:	83 ec 08             	sub    $0x8,%esp
801062dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062df:	50                   	push   %eax
801062e0:	6a 02                	push   $0x2
801062e2:	e8 99 f5 ff ff       	call   80105880 <argint>
     argint(1, &major) < 0 ||
801062e7:	83 c4 10             	add    $0x10,%esp
801062ea:	85 c0                	test   %eax,%eax
801062ec:	78 3a                	js     80106328 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801062ee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801062f2:	83 ec 0c             	sub    $0xc,%esp
801062f5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801062f9:	ba 03 00 00 00       	mov    $0x3,%edx
801062fe:	50                   	push   %eax
801062ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106302:	e8 d9 f6 ff ff       	call   801059e0 <create>
     argint(2, &minor) < 0 ||
80106307:	83 c4 10             	add    $0x10,%esp
8010630a:	85 c0                	test   %eax,%eax
8010630c:	74 1a                	je     80106328 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010630e:	83 ec 0c             	sub    $0xc,%esp
80106311:	50                   	push   %eax
80106312:	e8 f9 b6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106317:	e8 94 ca ff ff       	call   80102db0 <end_op>
  return 0;
8010631c:	83 c4 10             	add    $0x10,%esp
8010631f:	31 c0                	xor    %eax,%eax
}
80106321:	c9                   	leave  
80106322:	c3                   	ret    
80106323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106327:	90                   	nop
    end_op();
80106328:	e8 83 ca ff ff       	call   80102db0 <end_op>
    return -1;
8010632d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106332:	c9                   	leave  
80106333:	c3                   	ret    
80106334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop

80106340 <sys_chdir>:

int
sys_chdir(void)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
80106345:	89 e5                	mov    %esp,%ebp
80106347:	56                   	push   %esi
80106348:	53                   	push   %ebx
80106349:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010634c:	e8 8f d6 ff ff       	call   801039e0 <myproc>
80106351:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106353:	e8 e8 c9 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106358:	83 ec 08             	sub    $0x8,%esp
8010635b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010635e:	50                   	push   %eax
8010635f:	6a 00                	push   $0x0
80106361:	e8 ca f5 ff ff       	call   80105930 <argstr>
80106366:	83 c4 10             	add    $0x10,%esp
80106369:	85 c0                	test   %eax,%eax
8010636b:	78 73                	js     801063e0 <sys_chdir+0xa0>
8010636d:	83 ec 0c             	sub    $0xc,%esp
80106370:	ff 75 f4             	pushl  -0xc(%ebp)
80106373:	e8 c8 bc ff ff       	call   80102040 <namei>
80106378:	83 c4 10             	add    $0x10,%esp
8010637b:	89 c3                	mov    %eax,%ebx
8010637d:	85 c0                	test   %eax,%eax
8010637f:	74 5f                	je     801063e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106381:	83 ec 0c             	sub    $0xc,%esp
80106384:	50                   	push   %eax
80106385:	e8 e6 b3 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
8010638a:	83 c4 10             	add    $0x10,%esp
8010638d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106392:	75 2c                	jne    801063c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106394:	83 ec 0c             	sub    $0xc,%esp
80106397:	53                   	push   %ebx
80106398:	e8 b3 b4 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
8010639d:	58                   	pop    %eax
8010639e:	ff 76 68             	pushl  0x68(%esi)
801063a1:	e8 fa b4 ff ff       	call   801018a0 <iput>
  end_op();
801063a6:	e8 05 ca ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
801063ab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801063ae:	83 c4 10             	add    $0x10,%esp
801063b1:	31 c0                	xor    %eax,%eax
}
801063b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063b6:	5b                   	pop    %ebx
801063b7:	5e                   	pop    %esi
801063b8:	5d                   	pop    %ebp
801063b9:	c3                   	ret    
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	53                   	push   %ebx
801063c4:	e8 47 b6 ff ff       	call   80101a10 <iunlockput>
    end_op();
801063c9:	e8 e2 c9 ff ff       	call   80102db0 <end_op>
    return -1;
801063ce:	83 c4 10             	add    $0x10,%esp
801063d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d6:	eb db                	jmp    801063b3 <sys_chdir+0x73>
801063d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063df:	90                   	nop
    end_op();
801063e0:	e8 cb c9 ff ff       	call   80102db0 <end_op>
    return -1;
801063e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ea:	eb c7                	jmp    801063b3 <sys_chdir+0x73>
801063ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063f0 <sys_exec>:

int
sys_exec(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	57                   	push   %edi
801063f8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063f9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801063ff:	53                   	push   %ebx
80106400:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106406:	50                   	push   %eax
80106407:	6a 00                	push   $0x0
80106409:	e8 22 f5 ff ff       	call   80105930 <argstr>
8010640e:	83 c4 10             	add    $0x10,%esp
80106411:	85 c0                	test   %eax,%eax
80106413:	0f 88 8b 00 00 00    	js     801064a4 <sys_exec+0xb4>
80106419:	83 ec 08             	sub    $0x8,%esp
8010641c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106422:	50                   	push   %eax
80106423:	6a 01                	push   $0x1
80106425:	e8 56 f4 ff ff       	call   80105880 <argint>
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	85 c0                	test   %eax,%eax
8010642f:	78 73                	js     801064a4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106431:	83 ec 04             	sub    $0x4,%esp
80106434:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010643a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010643c:	68 80 00 00 00       	push   $0x80
80106441:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106447:	6a 00                	push   $0x0
80106449:	50                   	push   %eax
8010644a:	e8 51 f1 ff ff       	call   801055a0 <memset>
8010644f:	83 c4 10             	add    $0x10,%esp
80106452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106458:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010645e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106465:	83 ec 08             	sub    $0x8,%esp
80106468:	57                   	push   %edi
80106469:	01 f0                	add    %esi,%eax
8010646b:	50                   	push   %eax
8010646c:	e8 6f f3 ff ff       	call   801057e0 <fetchint>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	85 c0                	test   %eax,%eax
80106476:	78 2c                	js     801064a4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106478:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010647e:	85 c0                	test   %eax,%eax
80106480:	74 36                	je     801064b8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106482:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106488:	83 ec 08             	sub    $0x8,%esp
8010648b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010648e:	52                   	push   %edx
8010648f:	50                   	push   %eax
80106490:	e8 8b f3 ff ff       	call   80105820 <fetchstr>
80106495:	83 c4 10             	add    $0x10,%esp
80106498:	85 c0                	test   %eax,%eax
8010649a:	78 08                	js     801064a4 <sys_exec+0xb4>
  for(i=0;; i++){
8010649c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010649f:	83 fb 20             	cmp    $0x20,%ebx
801064a2:	75 b4                	jne    80106458 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801064a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801064a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ac:	5b                   	pop    %ebx
801064ad:	5e                   	pop    %esi
801064ae:	5f                   	pop    %edi
801064af:	5d                   	pop    %ebp
801064b0:	c3                   	ret    
801064b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801064b8:	83 ec 08             	sub    $0x8,%esp
801064bb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801064c1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801064c8:	00 00 00 00 
  return exec(path, argv);
801064cc:	50                   	push   %eax
801064cd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801064d3:	e8 a8 a5 ff ff       	call   80100a80 <exec>
801064d8:	83 c4 10             	add    $0x10,%esp
}
801064db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064de:	5b                   	pop    %ebx
801064df:	5e                   	pop    %esi
801064e0:	5f                   	pop    %edi
801064e1:	5d                   	pop    %ebp
801064e2:	c3                   	ret    
801064e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064f0 <sys_pipe>:

int
sys_pipe(void)
{
801064f0:	f3 0f 1e fb          	endbr32 
801064f4:	55                   	push   %ebp
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	57                   	push   %edi
801064f8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801064fc:	53                   	push   %ebx
801064fd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106500:	6a 08                	push   $0x8
80106502:	50                   	push   %eax
80106503:	6a 00                	push   $0x0
80106505:	e8 c6 f3 ff ff       	call   801058d0 <argptr>
8010650a:	83 c4 10             	add    $0x10,%esp
8010650d:	85 c0                	test   %eax,%eax
8010650f:	78 4e                	js     8010655f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106511:	83 ec 08             	sub    $0x8,%esp
80106514:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106517:	50                   	push   %eax
80106518:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010651b:	50                   	push   %eax
8010651c:	e8 df ce ff ff       	call   80103400 <pipealloc>
80106521:	83 c4 10             	add    $0x10,%esp
80106524:	85 c0                	test   %eax,%eax
80106526:	78 37                	js     8010655f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106528:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010652b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010652d:	e8 ae d4 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106538:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010653c:	85 f6                	test   %esi,%esi
8010653e:	74 30                	je     80106570 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106540:	83 c3 01             	add    $0x1,%ebx
80106543:	83 fb 10             	cmp    $0x10,%ebx
80106546:	75 f0                	jne    80106538 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106548:	83 ec 0c             	sub    $0xc,%esp
8010654b:	ff 75 e0             	pushl  -0x20(%ebp)
8010654e:	e8 7d a9 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80106553:	58                   	pop    %eax
80106554:	ff 75 e4             	pushl  -0x1c(%ebp)
80106557:	e8 74 a9 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010655c:	83 c4 10             	add    $0x10,%esp
8010655f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106564:	eb 5b                	jmp    801065c1 <sys_pipe+0xd1>
80106566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106570:	8d 73 08             	lea    0x8(%ebx),%esi
80106573:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010657a:	e8 61 d4 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010657f:	31 d2                	xor    %edx,%edx
80106581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106588:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010658c:	85 c9                	test   %ecx,%ecx
8010658e:	74 20                	je     801065b0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106590:	83 c2 01             	add    $0x1,%edx
80106593:	83 fa 10             	cmp    $0x10,%edx
80106596:	75 f0                	jne    80106588 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106598:	e8 43 d4 ff ff       	call   801039e0 <myproc>
8010659d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801065a4:	00 
801065a5:	eb a1                	jmp    80106548 <sys_pipe+0x58>
801065a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801065b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801065b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801065b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801065bf:	31 c0                	xor    %eax,%eax
}
801065c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c4:	5b                   	pop    %ebx
801065c5:	5e                   	pop    %esi
801065c6:	5f                   	pop    %edi
801065c7:	5d                   	pop    %ebp
801065c8:	c3                   	ret    
801065c9:	66 90                	xchg   %ax,%ax
801065cb:	66 90                	xchg   %ax,%ax
801065cd:	66 90                	xchg   %ax,%ax
801065cf:	90                   	nop

801065d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
  return fork();
801065d4:	e9 b7 d5 ff ff       	jmp    80103b90 <fork>
801065d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065e0 <sys_exit>:
}

int
sys_exit(void)
{
801065e0:	f3 0f 1e fb          	endbr32 
801065e4:	55                   	push   %ebp
801065e5:	89 e5                	mov    %esp,%ebp
801065e7:	83 ec 08             	sub    $0x8,%esp
  exit();
801065ea:	e8 71 db ff ff       	call   80104160 <exit>
  return 0;  // not reached
}
801065ef:	31 c0                	xor    %eax,%eax
801065f1:	c9                   	leave  
801065f2:	c3                   	ret    
801065f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106600 <sys_wait>:

int
sys_wait(void)
{
80106600:	f3 0f 1e fb          	endbr32 
  return wait();
80106604:	e9 a7 dd ff ff       	jmp    801043b0 <wait>
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106610 <sys_kill>:
}

int
sys_kill(void)
{
80106610:	f3 0f 1e fb          	endbr32 
80106614:	55                   	push   %ebp
80106615:	89 e5                	mov    %esp,%ebp
80106617:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010661a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010661d:	50                   	push   %eax
8010661e:	6a 00                	push   $0x0
80106620:	e8 5b f2 ff ff       	call   80105880 <argint>
80106625:	83 c4 10             	add    $0x10,%esp
80106628:	85 c0                	test   %eax,%eax
8010662a:	78 14                	js     80106640 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010662c:	83 ec 0c             	sub    $0xc,%esp
8010662f:	ff 75 f4             	pushl  -0xc(%ebp)
80106632:	e8 e9 de ff ff       	call   80104520 <kill>
80106637:	83 c4 10             	add    $0x10,%esp
}
8010663a:	c9                   	leave  
8010663b:	c3                   	ret    
8010663c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106640:	c9                   	leave  
    return -1;
80106641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106646:	c3                   	ret    
80106647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010664e:	66 90                	xchg   %ax,%ax

80106650 <sys_getpid>:

int
sys_getpid(void)
{
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	89 e5                	mov    %esp,%ebp
80106657:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010665a:	e8 81 d3 ff ff       	call   801039e0 <myproc>
8010665f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106662:	c9                   	leave  
80106663:	c3                   	ret    
80106664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010666f:	90                   	nop

80106670 <sys_sbrk>:

int
sys_sbrk(void)
{
80106670:	f3 0f 1e fb          	endbr32 
80106674:	55                   	push   %ebp
80106675:	89 e5                	mov    %esp,%ebp
80106677:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106678:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010667b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010667e:	50                   	push   %eax
8010667f:	6a 00                	push   $0x0
80106681:	e8 fa f1 ff ff       	call   80105880 <argint>
80106686:	83 c4 10             	add    $0x10,%esp
80106689:	85 c0                	test   %eax,%eax
8010668b:	78 23                	js     801066b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010668d:	e8 4e d3 ff ff       	call   801039e0 <myproc>
  if(growproc(n) < 0)
80106692:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106695:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106697:	ff 75 f4             	pushl  -0xc(%ebp)
8010669a:	e8 71 d4 ff ff       	call   80103b10 <growproc>
8010669f:	83 c4 10             	add    $0x10,%esp
801066a2:	85 c0                	test   %eax,%eax
801066a4:	78 0a                	js     801066b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801066a6:	89 d8                	mov    %ebx,%eax
801066a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066ab:	c9                   	leave  
801066ac:	c3                   	ret    
801066ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801066b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066b5:	eb ef                	jmp    801066a6 <sys_sbrk+0x36>
801066b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066be:	66 90                	xchg   %ax,%ax

801066c0 <sys_sleep>:

int
sys_sleep(void)
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
801066c5:	89 e5                	mov    %esp,%ebp
801066c7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801066ce:	50                   	push   %eax
801066cf:	6a 00                	push   $0x0
801066d1:	e8 aa f1 ff ff       	call   80105880 <argint>
801066d6:	83 c4 10             	add    $0x10,%esp
801066d9:	85 c0                	test   %eax,%eax
801066db:	0f 88 86 00 00 00    	js     80106767 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801066e1:	83 ec 0c             	sub    $0xc,%esp
801066e4:	68 60 80 11 80       	push   $0x80118060
801066e9:	e8 a2 ed ff ff       	call   80105490 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801066ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801066f1:	8b 1d a0 88 11 80    	mov    0x801188a0,%ebx
  while(ticks - ticks0 < n){
801066f7:	83 c4 10             	add    $0x10,%esp
801066fa:	85 d2                	test   %edx,%edx
801066fc:	75 23                	jne    80106721 <sys_sleep+0x61>
801066fe:	eb 50                	jmp    80106750 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106700:	83 ec 08             	sub    $0x8,%esp
80106703:	68 60 80 11 80       	push   $0x80118060
80106708:	68 a0 88 11 80       	push   $0x801188a0
8010670d:	e8 de db ff ff       	call   801042f0 <sleep>
  while(ticks - ticks0 < n){
80106712:	a1 a0 88 11 80       	mov    0x801188a0,%eax
80106717:	83 c4 10             	add    $0x10,%esp
8010671a:	29 d8                	sub    %ebx,%eax
8010671c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010671f:	73 2f                	jae    80106750 <sys_sleep+0x90>
    if(myproc()->killed){
80106721:	e8 ba d2 ff ff       	call   801039e0 <myproc>
80106726:	8b 40 24             	mov    0x24(%eax),%eax
80106729:	85 c0                	test   %eax,%eax
8010672b:	74 d3                	je     80106700 <sys_sleep+0x40>
      release(&tickslock);
8010672d:	83 ec 0c             	sub    $0xc,%esp
80106730:	68 60 80 11 80       	push   $0x80118060
80106735:	e8 16 ee ff ff       	call   80105550 <release>
  }
  release(&tickslock);
  return 0;
}
8010673a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010673d:	83 c4 10             	add    $0x10,%esp
80106740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106745:	c9                   	leave  
80106746:	c3                   	ret    
80106747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106750:	83 ec 0c             	sub    $0xc,%esp
80106753:	68 60 80 11 80       	push   $0x80118060
80106758:	e8 f3 ed ff ff       	call   80105550 <release>
  return 0;
8010675d:	83 c4 10             	add    $0x10,%esp
80106760:	31 c0                	xor    %eax,%eax
}
80106762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106765:	c9                   	leave  
80106766:	c3                   	ret    
    return -1;
80106767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676c:	eb f4                	jmp    80106762 <sys_sleep+0xa2>
8010676e:	66 90                	xchg   %ax,%ax

80106770 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	53                   	push   %ebx
80106778:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010677b:	68 60 80 11 80       	push   $0x80118060
80106780:	e8 0b ed ff ff       	call   80105490 <acquire>
  xticks = ticks;
80106785:	8b 1d a0 88 11 80    	mov    0x801188a0,%ebx
  release(&tickslock);
8010678b:	c7 04 24 60 80 11 80 	movl   $0x80118060,(%esp)
80106792:	e8 b9 ed ff ff       	call   80105550 <release>
  return xticks;
}
80106797:	89 d8                	mov    %ebx,%eax
80106799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010679c:	c9                   	leave  
8010679d:	c3                   	ret    
8010679e:	66 90                	xchg   %ax,%ax

801067a0 <sys_find_next_prime_number>:
int
sys_find_next_prime_number(void)
{
801067a0:	f3 0f 1e fb          	endbr32 
801067a4:	55                   	push   %ebp
801067a5:	89 e5                	mov    %esp,%ebp
801067a7:	53                   	push   %ebx
801067a8:	83 ec 04             	sub    $0x4,%esp
  int number = myproc()->tf->ebx; //register after eax
801067ab:	e8 30 d2 ff ff       	call   801039e0 <myproc>
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
801067b0:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; //register after eax
801067b3:	8b 40 18             	mov    0x18(%eax),%eax
801067b6:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
801067b9:	53                   	push   %ebx
801067ba:	68 20 8c 10 80       	push   $0x80108c20
801067bf:	e8 ec 9e ff ff       	call   801006b0 <cprintf>
  return find_next_prime_number(number);
801067c4:	89 1c 24             	mov    %ebx,(%esp)
801067c7:	e8 94 e2 ff ff       	call   80104a60 <find_next_prime_number>
}
801067cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067cf:	c9                   	leave  
801067d0:	c3                   	ret    
801067d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067df:	90                   	nop

801067e0 <sys_get_call_count>:

int 
sys_get_call_count(void)
{
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	53                   	push   %ebx
801067e8:	83 ec 14             	sub    $0x14,%esp
  int  *cnt;
  int sys_num;
  struct proc *curproc = myproc();
801067eb:	e8 f0 d1 ff ff       	call   801039e0 <myproc>
  argint(0, &sys_num);
801067f0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801067f3:	89 c3                	mov    %eax,%ebx
  argint(0, &sys_num);
801067f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067f8:	50                   	push   %eax
801067f9:	6a 00                	push   $0x0
801067fb:	e8 80 f0 ff ff       	call   80105880 <argint>
  cnt = curproc->syscnt;
  return *(cnt+sys_num-1);
80106800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106803:	8b 44 83 78          	mov    0x78(%ebx,%eax,4),%eax
}
80106807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010680a:	c9                   	leave  
8010680b:	c3                   	ret    
8010680c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106810 <sys_get_most_caller>:

int
sys_get_most_caller(void)
{
80106810:	f3 0f 1e fb          	endbr32 
80106814:	55                   	push   %ebp
80106815:	89 e5                	mov    %esp,%ebp
80106817:	83 ec 20             	sub    $0x20,%esp
  int sys_num;
  argint(0, &sys_num);
8010681a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010681d:	50                   	push   %eax
8010681e:	6a 00                	push   $0x0
80106820:	e8 5b f0 ff ff       	call   80105880 <argint>
  return get_most_caller(sys_num);
80106825:	58                   	pop    %eax
80106826:	ff 75 f4             	pushl  -0xc(%ebp)
80106829:	e8 f2 e8 ff ff       	call   80105120 <get_most_caller>
}
8010682e:	c9                   	leave  
8010682f:	c3                   	ret    

80106830 <sys_wait_for_process>:

int 
sys_wait_for_process(void)
{
80106830:	f3 0f 1e fb          	endbr32 
80106834:	55                   	push   %ebp
80106835:	89 e5                	mov    %esp,%ebp
80106837:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
8010683a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683d:	50                   	push   %eax
8010683e:	6a 00                	push   $0x0
80106840:	e8 3b f0 ff ff       	call   80105880 <argint>
  return wait_for_process(pid);
80106845:	58                   	pop    %eax
80106846:	ff 75 f4             	pushl  -0xc(%ebp)
80106849:	e8 d2 e7 ff ff       	call   80105020 <wait_for_process>

}
8010684e:	c9                   	leave  
8010684f:	c3                   	ret    

80106850 <sys_set_proc_queue>:


int
sys_set_proc_queue(void)
{
80106850:	f3 0f 1e fb          	endbr32 
80106854:	55                   	push   %ebp
80106855:	89 e5                	mov    %esp,%ebp
80106857:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
8010685a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010685d:	50                   	push   %eax
8010685e:	6a 00                	push   $0x0
80106860:	e8 1b f0 ff ff       	call   80105880 <argint>
80106865:	83 c4 10             	add    $0x10,%esp
80106868:	85 c0                	test   %eax,%eax
8010686a:	78 34                	js     801068a0 <sys_set_proc_queue+0x50>
    return -1;

  int q_num;
  if(argint(1, &q_num) < 0)
8010686c:	83 ec 08             	sub    $0x8,%esp
8010686f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106872:	50                   	push   %eax
80106873:	6a 01                	push   $0x1
80106875:	e8 06 f0 ff ff       	call   80105880 <argint>
8010687a:	83 c4 10             	add    $0x10,%esp
8010687d:	85 c0                	test   %eax,%eax
8010687f:	78 1f                	js     801068a0 <sys_set_proc_queue+0x50>
    return -1;
  
  set_proc_queue(pid, q_num);
80106881:	83 ec 08             	sub    $0x8,%esp
80106884:	ff 75 f4             	pushl  -0xc(%ebp)
80106887:	ff 75 f0             	pushl  -0x10(%ebp)
8010688a:	e8 41 de ff ff       	call   801046d0 <set_proc_queue>
  return 0;
8010688f:	83 c4 10             	add    $0x10,%esp
80106892:	31 c0                	xor    %eax,%eax
}
80106894:	c9                   	leave  
80106895:	c3                   	ret    
80106896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689d:	8d 76 00             	lea    0x0(%esi),%esi
801068a0:	c9                   	leave  
    return -1;
801068a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068a6:	c3                   	ret    
801068a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ae:	66 90                	xchg   %ax,%ax

801068b0 <sys_set_tickets>:

int
sys_set_tickets(void)
{
801068b0:	f3 0f 1e fb          	endbr32 
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
801068ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068bd:	50                   	push   %eax
801068be:	6a 00                	push   $0x0
801068c0:	e8 bb ef ff ff       	call   80105880 <argint>
801068c5:	83 c4 10             	add    $0x10,%esp
801068c8:	85 c0                	test   %eax,%eax
801068ca:	78 34                	js     80106900 <sys_set_tickets+0x50>
    return -1;

  int tickets;
  if(argint(1, &tickets) < 0)
801068cc:	83 ec 08             	sub    $0x8,%esp
801068cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068d2:	50                   	push   %eax
801068d3:	6a 01                	push   $0x1
801068d5:	e8 a6 ef ff ff       	call   80105880 <argint>
801068da:	83 c4 10             	add    $0x10,%esp
801068dd:	85 c0                	test   %eax,%eax
801068df:	78 1f                	js     80106900 <sys_set_tickets+0x50>
    return -1;

  set_tickets(pid, tickets);
801068e1:	83 ec 08             	sub    $0x8,%esp
801068e4:	ff 75 f4             	pushl  -0xc(%ebp)
801068e7:	ff 75 f0             	pushl  -0x10(%ebp)
801068ea:	e8 a1 dd ff ff       	call   80104690 <set_tickets>
  return 0;
801068ef:	83 c4 10             	add    $0x10,%esp
801068f2:	31 c0                	xor    %eax,%eax
}
801068f4:	c9                   	leave  
801068f5:	c3                   	ret    
801068f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068fd:	8d 76 00             	lea    0x0(%esi),%esi
80106900:	c9                   	leave  
    return -1;
80106901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106906:	c3                   	ret    
80106907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690e:	66 90                	xchg   %ax,%ax

80106910 <sys_set_bjf_params_in_proc>:

int
sys_set_bjf_params_in_proc(void)
{
80106910:	f3 0f 1e fb          	endbr32 
80106914:	55                   	push   %ebp
80106915:	89 e5                	mov    %esp,%ebp
80106917:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
8010691a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010691d:	50                   	push   %eax
8010691e:	6a 00                	push   $0x0
80106920:	e8 5b ef ff ff       	call   80105880 <argint>
80106925:	83 c4 10             	add    $0x10,%esp
80106928:	85 c0                	test   %eax,%eax
8010692a:	78 5c                	js     80106988 <sys_set_bjf_params_in_proc+0x78>
    return -1;

  int pratio;
  if(argint(1, &pratio) < 0)
8010692c:	83 ec 08             	sub    $0x8,%esp
8010692f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106932:	50                   	push   %eax
80106933:	6a 01                	push   $0x1
80106935:	e8 46 ef ff ff       	call   80105880 <argint>
8010693a:	83 c4 10             	add    $0x10,%esp
8010693d:	85 c0                	test   %eax,%eax
8010693f:	78 47                	js     80106988 <sys_set_bjf_params_in_proc+0x78>
    return -1;

  int atratio;
  if(argint(2, &atratio) < 0)
80106941:	83 ec 08             	sub    $0x8,%esp
80106944:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106947:	50                   	push   %eax
80106948:	6a 02                	push   $0x2
8010694a:	e8 31 ef ff ff       	call   80105880 <argint>
8010694f:	83 c4 10             	add    $0x10,%esp
80106952:	85 c0                	test   %eax,%eax
80106954:	78 32                	js     80106988 <sys_set_bjf_params_in_proc+0x78>
    return -1;
  
  int ecratio;
  if(argint(3, &ecratio) < 0)
80106956:	83 ec 08             	sub    $0x8,%esp
80106959:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010695c:	50                   	push   %eax
8010695d:	6a 03                	push   $0x3
8010695f:	e8 1c ef ff ff       	call   80105880 <argint>
80106964:	83 c4 10             	add    $0x10,%esp
80106967:	85 c0                	test   %eax,%eax
80106969:	78 1d                	js     80106988 <sys_set_bjf_params_in_proc+0x78>
    return -1;

  set_bjf_params_in_proc(pid, pratio, atratio, ecratio);
8010696b:	ff 75 f4             	pushl  -0xc(%ebp)
8010696e:	ff 75 f0             	pushl  -0x10(%ebp)
80106971:	ff 75 ec             	pushl  -0x14(%ebp)
80106974:	ff 75 e8             	pushl  -0x18(%ebp)
80106977:	e8 94 dd ff ff       	call   80104710 <set_bjf_params_in_proc>
  return 0;
8010697c:	83 c4 10             	add    $0x10,%esp
8010697f:	31 c0                	xor    %eax,%eax
}
80106981:	c9                   	leave  
80106982:	c3                   	ret    
80106983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106987:	90                   	nop
80106988:	c9                   	leave  
    return -1;
80106989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010698e:	c3                   	ret    
8010698f:	90                   	nop

80106990 <sys_set_bjf_params_in_system>:

int
sys_set_bjf_params_in_system(void)
{
80106990:	f3 0f 1e fb          	endbr32 
80106994:	55                   	push   %ebp
80106995:	89 e5                	mov    %esp,%ebp
80106997:	83 ec 20             	sub    $0x20,%esp
  int pratio;
  if(argint(0, &pratio) < 0)
8010699a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010699d:	50                   	push   %eax
8010699e:	6a 00                	push   $0x0
801069a0:	e8 db ee ff ff       	call   80105880 <argint>
801069a5:	83 c4 10             	add    $0x10,%esp
801069a8:	85 c0                	test   %eax,%eax
801069aa:	78 44                	js     801069f0 <sys_set_bjf_params_in_system+0x60>
    return -1;

  int atratio;
  if(argint(1, &atratio) < 0)
801069ac:	83 ec 08             	sub    $0x8,%esp
801069af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069b2:	50                   	push   %eax
801069b3:	6a 01                	push   $0x1
801069b5:	e8 c6 ee ff ff       	call   80105880 <argint>
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	85 c0                	test   %eax,%eax
801069bf:	78 2f                	js     801069f0 <sys_set_bjf_params_in_system+0x60>
    return -1;
  
  int ecratio;
  if(argint(2, &ecratio) < 0)
801069c1:	83 ec 08             	sub    $0x8,%esp
801069c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069c7:	50                   	push   %eax
801069c8:	6a 02                	push   $0x2
801069ca:	e8 b1 ee ff ff       	call   80105880 <argint>
801069cf:	83 c4 10             	add    $0x10,%esp
801069d2:	85 c0                	test   %eax,%eax
801069d4:	78 1a                	js     801069f0 <sys_set_bjf_params_in_system+0x60>
    return -1;
  
  set_bjf_params_in_system(pratio, atratio, ecratio);
801069d6:	83 ec 04             	sub    $0x4,%esp
801069d9:	ff 75 f4             	pushl  -0xc(%ebp)
801069dc:	ff 75 f0             	pushl  -0x10(%ebp)
801069df:	ff 75 ec             	pushl  -0x14(%ebp)
801069e2:	e8 79 dd ff ff       	call   80104760 <set_bjf_params_in_system>
  return 0;
801069e7:	83 c4 10             	add    $0x10,%esp
801069ea:	31 c0                	xor    %eax,%eax
}
801069ec:	c9                   	leave  
801069ed:	c3                   	ret    
801069ee:	66 90                	xchg   %ax,%ax
801069f0:	c9                   	leave  
    return -1;
801069f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069f6:	c3                   	ret    
801069f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069fe:	66 90                	xchg   %ax,%ax

80106a00 <sys_print_info>:

int
sys_print_info(void)
{
80106a00:	f3 0f 1e fb          	endbr32 
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	83 ec 08             	sub    $0x8,%esp
  print_info();
80106a0a:	e8 e1 e0 ff ff       	call   80104af0 <print_info>
  return 0;
}
80106a0f:	31 c0                	xor    %eax,%eax
80106a11:	c9                   	leave  
80106a12:	c3                   	ret    

80106a13 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a13:	1e                   	push   %ds
  pushl %es
80106a14:	06                   	push   %es
  pushl %fs
80106a15:	0f a0                	push   %fs
  pushl %gs
80106a17:	0f a8                	push   %gs
  pushal
80106a19:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106a1a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a1e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a20:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a22:	54                   	push   %esp
  call trap
80106a23:	e8 c8 00 00 00       	call   80106af0 <trap>
  addl $4, %esp
80106a28:	83 c4 04             	add    $0x4,%esp

80106a2b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a2b:	61                   	popa   
  popl %gs
80106a2c:	0f a9                	pop    %gs
  popl %fs
80106a2e:	0f a1                	pop    %fs
  popl %es
80106a30:	07                   	pop    %es
  popl %ds
80106a31:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a32:	83 c4 08             	add    $0x8,%esp
  iret
80106a35:	cf                   	iret   
80106a36:	66 90                	xchg   %ax,%ax
80106a38:	66 90                	xchg   %ax,%ax
80106a3a:	66 90                	xchg   %ax,%ax
80106a3c:	66 90                	xchg   %ax,%ax
80106a3e:	66 90                	xchg   %ax,%ax

80106a40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a40:	f3 0f 1e fb          	endbr32 
80106a44:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106a45:	31 c0                	xor    %eax,%eax
{
80106a47:	89 e5                	mov    %esp,%ebp
80106a49:	83 ec 08             	sub    $0x8,%esp
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106a57:	c7 04 c5 a2 80 11 80 	movl   $0x8e000008,-0x7fee7f5e(,%eax,8)
80106a5e:	08 00 00 8e 
80106a62:	66 89 14 c5 a0 80 11 	mov    %dx,-0x7fee7f60(,%eax,8)
80106a69:	80 
80106a6a:	c1 ea 10             	shr    $0x10,%edx
80106a6d:	66 89 14 c5 a6 80 11 	mov    %dx,-0x7fee7f5a(,%eax,8)
80106a74:	80 
  for(i = 0; i < 256; i++)
80106a75:	83 c0 01             	add    $0x1,%eax
80106a78:	3d 00 01 00 00       	cmp    $0x100,%eax
80106a7d:	75 d1                	jne    80106a50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106a7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106a87:	c7 05 a2 82 11 80 08 	movl   $0xef000008,0x801182a2
80106a8e:	00 00 ef 
  initlock(&tickslock, "time");
80106a91:	68 58 8c 10 80       	push   $0x80108c58
80106a96:	68 60 80 11 80       	push   $0x80118060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a9b:	66 a3 a0 82 11 80    	mov    %ax,0x801182a0
80106aa1:	c1 e8 10             	shr    $0x10,%eax
80106aa4:	66 a3 a6 82 11 80    	mov    %ax,0x801182a6
  initlock(&tickslock, "time");
80106aaa:	e8 61 e8 ff ff       	call   80105310 <initlock>
}
80106aaf:	83 c4 10             	add    $0x10,%esp
80106ab2:	c9                   	leave  
80106ab3:	c3                   	ret    
80106ab4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106abf:	90                   	nop

80106ac0 <idtinit>:

void
idtinit(void)
{
80106ac0:	f3 0f 1e fb          	endbr32 
80106ac4:	55                   	push   %ebp
  pd[0] = size-1;
80106ac5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106aca:	89 e5                	mov    %esp,%ebp
80106acc:	83 ec 10             	sub    $0x10,%esp
80106acf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ad3:	b8 a0 80 11 80       	mov    $0x801180a0,%eax
80106ad8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106adc:	c1 e8 10             	shr    $0x10,%eax
80106adf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106ae3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ae6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106ae9:	c9                   	leave  
80106aea:	c3                   	ret    
80106aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aef:	90                   	nop

80106af0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106af0:	f3 0f 1e fb          	endbr32 
80106af4:	55                   	push   %ebp
80106af5:	89 e5                	mov    %esp,%ebp
80106af7:	57                   	push   %edi
80106af8:	56                   	push   %esi
80106af9:	53                   	push   %ebx
80106afa:	83 ec 1c             	sub    $0x1c,%esp
80106afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106b00:	8b 43 30             	mov    0x30(%ebx),%eax
80106b03:	83 f8 40             	cmp    $0x40,%eax
80106b06:	0f 84 bc 01 00 00    	je     80106cc8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106b0c:	83 e8 20             	sub    $0x20,%eax
80106b0f:	83 f8 1f             	cmp    $0x1f,%eax
80106b12:	77 08                	ja     80106b1c <trap+0x2c>
80106b14:	3e ff 24 85 00 8d 10 	notrack jmp *-0x7fef7300(,%eax,4)
80106b1b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106b1c:	e8 bf ce ff ff       	call   801039e0 <myproc>
80106b21:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b24:	85 c0                	test   %eax,%eax
80106b26:	0f 84 eb 01 00 00    	je     80106d17 <trap+0x227>
80106b2c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106b30:	0f 84 e1 01 00 00    	je     80106d17 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b36:	0f 20 d1             	mov    %cr2,%ecx
80106b39:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b3c:	e8 7f ce ff ff       	call   801039c0 <cpuid>
80106b41:	8b 73 30             	mov    0x30(%ebx),%esi
80106b44:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b47:	8b 43 34             	mov    0x34(%ebx),%eax
80106b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106b4d:	e8 8e ce ff ff       	call   801039e0 <myproc>
80106b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b55:	e8 86 ce ff ff       	call   801039e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b5a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106b5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b60:	51                   	push   %ecx
80106b61:	57                   	push   %edi
80106b62:	52                   	push   %edx
80106b63:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b66:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106b67:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106b6a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b6d:	56                   	push   %esi
80106b6e:	ff 70 10             	pushl  0x10(%eax)
80106b71:	68 bc 8c 10 80       	push   $0x80108cbc
80106b76:	e8 35 9b ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106b7b:	83 c4 20             	add    $0x20,%esp
80106b7e:	e8 5d ce ff ff       	call   801039e0 <myproc>
80106b83:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b8a:	e8 51 ce ff ff       	call   801039e0 <myproc>
80106b8f:	85 c0                	test   %eax,%eax
80106b91:	74 1d                	je     80106bb0 <trap+0xc0>
80106b93:	e8 48 ce ff ff       	call   801039e0 <myproc>
80106b98:	8b 50 24             	mov    0x24(%eax),%edx
80106b9b:	85 d2                	test   %edx,%edx
80106b9d:	74 11                	je     80106bb0 <trap+0xc0>
80106b9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106ba3:	83 e0 03             	and    $0x3,%eax
80106ba6:	66 83 f8 03          	cmp    $0x3,%ax
80106baa:	0f 84 50 01 00 00    	je     80106d00 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106bb0:	e8 2b ce ff ff       	call   801039e0 <myproc>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	74 0f                	je     80106bc8 <trap+0xd8>
80106bb9:	e8 22 ce ff ff       	call   801039e0 <myproc>
80106bbe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106bc2:	0f 84 e8 00 00 00    	je     80106cb0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bc8:	e8 13 ce ff ff       	call   801039e0 <myproc>
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	74 1d                	je     80106bee <trap+0xfe>
80106bd1:	e8 0a ce ff ff       	call   801039e0 <myproc>
80106bd6:	8b 40 24             	mov    0x24(%eax),%eax
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	74 11                	je     80106bee <trap+0xfe>
80106bdd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106be1:	83 e0 03             	and    $0x3,%eax
80106be4:	66 83 f8 03          	cmp    $0x3,%ax
80106be8:	0f 84 03 01 00 00    	je     80106cf1 <trap+0x201>
    exit();
}
80106bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf1:	5b                   	pop    %ebx
80106bf2:	5e                   	pop    %esi
80106bf3:	5f                   	pop    %edi
80106bf4:	5d                   	pop    %ebp
80106bf5:	c3                   	ret    
    ideintr();
80106bf6:	e8 f5 b5 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
80106bfb:	e8 d0 bc ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c00:	e8 db cd ff ff       	call   801039e0 <myproc>
80106c05:	85 c0                	test   %eax,%eax
80106c07:	75 8a                	jne    80106b93 <trap+0xa3>
80106c09:	eb a5                	jmp    80106bb0 <trap+0xc0>
    if(cpuid() == 0){
80106c0b:	e8 b0 cd ff ff       	call   801039c0 <cpuid>
80106c10:	85 c0                	test   %eax,%eax
80106c12:	75 e7                	jne    80106bfb <trap+0x10b>
      acquire(&tickslock);
80106c14:	83 ec 0c             	sub    $0xc,%esp
80106c17:	68 60 80 11 80       	push   $0x80118060
80106c1c:	e8 6f e8 ff ff       	call   80105490 <acquire>
      wakeup(&ticks);
80106c21:	c7 04 24 a0 88 11 80 	movl   $0x801188a0,(%esp)
      ticks++;
80106c28:	83 05 a0 88 11 80 01 	addl   $0x1,0x801188a0
      wakeup(&ticks);
80106c2f:	e8 7c d8 ff ff       	call   801044b0 <wakeup>
      release(&tickslock);
80106c34:	c7 04 24 60 80 11 80 	movl   $0x80118060,(%esp)
80106c3b:	e8 10 e9 ff ff       	call   80105550 <release>
80106c40:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106c43:	eb b6                	jmp    80106bfb <trap+0x10b>
    kbdintr();
80106c45:	e8 46 bb ff ff       	call   80102790 <kbdintr>
    lapiceoi();
80106c4a:	e8 81 bc ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c4f:	e8 8c cd ff ff       	call   801039e0 <myproc>
80106c54:	85 c0                	test   %eax,%eax
80106c56:	0f 85 37 ff ff ff    	jne    80106b93 <trap+0xa3>
80106c5c:	e9 4f ff ff ff       	jmp    80106bb0 <trap+0xc0>
    uartintr();
80106c61:	e8 4a 02 00 00       	call   80106eb0 <uartintr>
    lapiceoi();
80106c66:	e8 65 bc ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c6b:	e8 70 cd ff ff       	call   801039e0 <myproc>
80106c70:	85 c0                	test   %eax,%eax
80106c72:	0f 85 1b ff ff ff    	jne    80106b93 <trap+0xa3>
80106c78:	e9 33 ff ff ff       	jmp    80106bb0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c7d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c80:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106c84:	e8 37 cd ff ff       	call   801039c0 <cpuid>
80106c89:	57                   	push   %edi
80106c8a:	56                   	push   %esi
80106c8b:	50                   	push   %eax
80106c8c:	68 64 8c 10 80       	push   $0x80108c64
80106c91:	e8 1a 9a ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106c96:	e8 35 bc ff ff       	call   801028d0 <lapiceoi>
    break;
80106c9b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c9e:	e8 3d cd ff ff       	call   801039e0 <myproc>
80106ca3:	85 c0                	test   %eax,%eax
80106ca5:	0f 85 e8 fe ff ff    	jne    80106b93 <trap+0xa3>
80106cab:	e9 00 ff ff ff       	jmp    80106bb0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106cb0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106cb4:	0f 85 0e ff ff ff    	jne    80106bc8 <trap+0xd8>
    yield();
80106cba:	e8 e1 d5 ff ff       	call   801042a0 <yield>
80106cbf:	e9 04 ff ff ff       	jmp    80106bc8 <trap+0xd8>
80106cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106cc8:	e8 13 cd ff ff       	call   801039e0 <myproc>
80106ccd:	8b 70 24             	mov    0x24(%eax),%esi
80106cd0:	85 f6                	test   %esi,%esi
80106cd2:	75 3c                	jne    80106d10 <trap+0x220>
    myproc()->tf = tf;
80106cd4:	e8 07 cd ff ff       	call   801039e0 <myproc>
80106cd9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106cdc:	e8 8f ec ff ff       	call   80105970 <syscall>
    if(myproc()->killed)
80106ce1:	e8 fa cc ff ff       	call   801039e0 <myproc>
80106ce6:	8b 48 24             	mov    0x24(%eax),%ecx
80106ce9:	85 c9                	test   %ecx,%ecx
80106ceb:	0f 84 fd fe ff ff    	je     80106bee <trap+0xfe>
}
80106cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf4:	5b                   	pop    %ebx
80106cf5:	5e                   	pop    %esi
80106cf6:	5f                   	pop    %edi
80106cf7:	5d                   	pop    %ebp
      exit();
80106cf8:	e9 63 d4 ff ff       	jmp    80104160 <exit>
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106d00:	e8 5b d4 ff ff       	call   80104160 <exit>
80106d05:	e9 a6 fe ff ff       	jmp    80106bb0 <trap+0xc0>
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106d10:	e8 4b d4 ff ff       	call   80104160 <exit>
80106d15:	eb bd                	jmp    80106cd4 <trap+0x1e4>
80106d17:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d1a:	e8 a1 cc ff ff       	call   801039c0 <cpuid>
80106d1f:	83 ec 0c             	sub    $0xc,%esp
80106d22:	56                   	push   %esi
80106d23:	57                   	push   %edi
80106d24:	50                   	push   %eax
80106d25:	ff 73 30             	pushl  0x30(%ebx)
80106d28:	68 88 8c 10 80       	push   $0x80108c88
80106d2d:	e8 7e 99 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106d32:	83 c4 14             	add    $0x14,%esp
80106d35:	68 5d 8c 10 80       	push   $0x80108c5d
80106d3a:	e8 51 96 ff ff       	call   80100390 <panic>
80106d3f:	90                   	nop

80106d40 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106d40:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106d44:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106d49:	85 c0                	test   %eax,%eax
80106d4b:	74 1b                	je     80106d68 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d4d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d52:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106d53:	a8 01                	test   $0x1,%al
80106d55:	74 11                	je     80106d68 <uartgetc+0x28>
80106d57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d5c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106d5d:	0f b6 c0             	movzbl %al,%eax
80106d60:	c3                   	ret    
80106d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d6d:	c3                   	ret    
80106d6e:	66 90                	xchg   %ax,%ax

80106d70 <uartputc.part.0>:
uartputc(int c)
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	89 c7                	mov    %eax,%edi
80106d76:	56                   	push   %esi
80106d77:	be fd 03 00 00       	mov    $0x3fd,%esi
80106d7c:	53                   	push   %ebx
80106d7d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	eb 1b                	jmp    80106da2 <uartputc.part.0+0x32>
80106d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	6a 0a                	push   $0xa
80106d95:	e8 56 bb ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d9a:	83 c4 10             	add    $0x10,%esp
80106d9d:	83 eb 01             	sub    $0x1,%ebx
80106da0:	74 07                	je     80106da9 <uartputc.part.0+0x39>
80106da2:	89 f2                	mov    %esi,%edx
80106da4:	ec                   	in     (%dx),%al
80106da5:	a8 20                	test   $0x20,%al
80106da7:	74 e7                	je     80106d90 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106da9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dae:	89 f8                	mov    %edi,%eax
80106db0:	ee                   	out    %al,(%dx)
}
80106db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db4:	5b                   	pop    %ebx
80106db5:	5e                   	pop    %esi
80106db6:	5f                   	pop    %edi
80106db7:	5d                   	pop    %ebp
80106db8:	c3                   	ret    
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <uartinit>:
{
80106dc0:	f3 0f 1e fb          	endbr32 
80106dc4:	55                   	push   %ebp
80106dc5:	31 c9                	xor    %ecx,%ecx
80106dc7:	89 c8                	mov    %ecx,%eax
80106dc9:	89 e5                	mov    %esp,%ebp
80106dcb:	57                   	push   %edi
80106dcc:	56                   	push   %esi
80106dcd:	53                   	push   %ebx
80106dce:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106dd3:	89 da                	mov    %ebx,%edx
80106dd5:	83 ec 0c             	sub    $0xc,%esp
80106dd8:	ee                   	out    %al,(%dx)
80106dd9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106dde:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106de3:	89 fa                	mov    %edi,%edx
80106de5:	ee                   	out    %al,(%dx)
80106de6:	b8 0c 00 00 00       	mov    $0xc,%eax
80106deb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106df0:	ee                   	out    %al,(%dx)
80106df1:	be f9 03 00 00       	mov    $0x3f9,%esi
80106df6:	89 c8                	mov    %ecx,%eax
80106df8:	89 f2                	mov    %esi,%edx
80106dfa:	ee                   	out    %al,(%dx)
80106dfb:	b8 03 00 00 00       	mov    $0x3,%eax
80106e00:	89 fa                	mov    %edi,%edx
80106e02:	ee                   	out    %al,(%dx)
80106e03:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106e08:	89 c8                	mov    %ecx,%eax
80106e0a:	ee                   	out    %al,(%dx)
80106e0b:	b8 01 00 00 00       	mov    $0x1,%eax
80106e10:	89 f2                	mov    %esi,%edx
80106e12:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e13:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e18:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106e19:	3c ff                	cmp    $0xff,%al
80106e1b:	74 52                	je     80106e6f <uartinit+0xaf>
  uart = 1;
80106e1d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106e24:	00 00 00 
80106e27:	89 da                	mov    %ebx,%edx
80106e29:	ec                   	in     (%dx),%al
80106e2a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e2f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106e30:	83 ec 08             	sub    $0x8,%esp
80106e33:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106e38:	bb 80 8d 10 80       	mov    $0x80108d80,%ebx
  ioapicenable(IRQ_COM1, 0);
80106e3d:	6a 00                	push   $0x0
80106e3f:	6a 04                	push   $0x4
80106e41:	e8 fa b5 ff ff       	call   80102440 <ioapicenable>
80106e46:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106e49:	b8 78 00 00 00       	mov    $0x78,%eax
80106e4e:	eb 04                	jmp    80106e54 <uartinit+0x94>
80106e50:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106e54:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106e5a:	85 d2                	test   %edx,%edx
80106e5c:	74 08                	je     80106e66 <uartinit+0xa6>
    uartputc(*p);
80106e5e:	0f be c0             	movsbl %al,%eax
80106e61:	e8 0a ff ff ff       	call   80106d70 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106e66:	89 f0                	mov    %esi,%eax
80106e68:	83 c3 01             	add    $0x1,%ebx
80106e6b:	84 c0                	test   %al,%al
80106e6d:	75 e1                	jne    80106e50 <uartinit+0x90>
}
80106e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e72:	5b                   	pop    %ebx
80106e73:	5e                   	pop    %esi
80106e74:	5f                   	pop    %edi
80106e75:	5d                   	pop    %ebp
80106e76:	c3                   	ret    
80106e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7e:	66 90                	xchg   %ax,%ax

80106e80 <uartputc>:
{
80106e80:	f3 0f 1e fb          	endbr32 
80106e84:	55                   	push   %ebp
  if(!uart)
80106e85:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106e8b:	89 e5                	mov    %esp,%ebp
80106e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106e90:	85 d2                	test   %edx,%edx
80106e92:	74 0c                	je     80106ea0 <uartputc+0x20>
}
80106e94:	5d                   	pop    %ebp
80106e95:	e9 d6 fe ff ff       	jmp    80106d70 <uartputc.part.0>
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <uartintr>:

void
uartintr(void)
{
80106eb0:	f3 0f 1e fb          	endbr32 
80106eb4:	55                   	push   %ebp
80106eb5:	89 e5                	mov    %esp,%ebp
80106eb7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106eba:	68 40 6d 10 80       	push   $0x80106d40
80106ebf:	e8 9c 99 ff ff       	call   80100860 <consoleintr>
}
80106ec4:	83 c4 10             	add    $0x10,%esp
80106ec7:	c9                   	leave  
80106ec8:	c3                   	ret    

80106ec9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $0
80106ecb:	6a 00                	push   $0x0
  jmp alltraps
80106ecd:	e9 41 fb ff ff       	jmp    80106a13 <alltraps>

80106ed2 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $1
80106ed4:	6a 01                	push   $0x1
  jmp alltraps
80106ed6:	e9 38 fb ff ff       	jmp    80106a13 <alltraps>

80106edb <vector2>:
.globl vector2
vector2:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $2
80106edd:	6a 02                	push   $0x2
  jmp alltraps
80106edf:	e9 2f fb ff ff       	jmp    80106a13 <alltraps>

80106ee4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $3
80106ee6:	6a 03                	push   $0x3
  jmp alltraps
80106ee8:	e9 26 fb ff ff       	jmp    80106a13 <alltraps>

80106eed <vector4>:
.globl vector4
vector4:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $4
80106eef:	6a 04                	push   $0x4
  jmp alltraps
80106ef1:	e9 1d fb ff ff       	jmp    80106a13 <alltraps>

80106ef6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $5
80106ef8:	6a 05                	push   $0x5
  jmp alltraps
80106efa:	e9 14 fb ff ff       	jmp    80106a13 <alltraps>

80106eff <vector6>:
.globl vector6
vector6:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $6
80106f01:	6a 06                	push   $0x6
  jmp alltraps
80106f03:	e9 0b fb ff ff       	jmp    80106a13 <alltraps>

80106f08 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $7
80106f0a:	6a 07                	push   $0x7
  jmp alltraps
80106f0c:	e9 02 fb ff ff       	jmp    80106a13 <alltraps>

80106f11 <vector8>:
.globl vector8
vector8:
  pushl $8
80106f11:	6a 08                	push   $0x8
  jmp alltraps
80106f13:	e9 fb fa ff ff       	jmp    80106a13 <alltraps>

80106f18 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $9
80106f1a:	6a 09                	push   $0x9
  jmp alltraps
80106f1c:	e9 f2 fa ff ff       	jmp    80106a13 <alltraps>

80106f21 <vector10>:
.globl vector10
vector10:
  pushl $10
80106f21:	6a 0a                	push   $0xa
  jmp alltraps
80106f23:	e9 eb fa ff ff       	jmp    80106a13 <alltraps>

80106f28 <vector11>:
.globl vector11
vector11:
  pushl $11
80106f28:	6a 0b                	push   $0xb
  jmp alltraps
80106f2a:	e9 e4 fa ff ff       	jmp    80106a13 <alltraps>

80106f2f <vector12>:
.globl vector12
vector12:
  pushl $12
80106f2f:	6a 0c                	push   $0xc
  jmp alltraps
80106f31:	e9 dd fa ff ff       	jmp    80106a13 <alltraps>

80106f36 <vector13>:
.globl vector13
vector13:
  pushl $13
80106f36:	6a 0d                	push   $0xd
  jmp alltraps
80106f38:	e9 d6 fa ff ff       	jmp    80106a13 <alltraps>

80106f3d <vector14>:
.globl vector14
vector14:
  pushl $14
80106f3d:	6a 0e                	push   $0xe
  jmp alltraps
80106f3f:	e9 cf fa ff ff       	jmp    80106a13 <alltraps>

80106f44 <vector15>:
.globl vector15
vector15:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $15
80106f46:	6a 0f                	push   $0xf
  jmp alltraps
80106f48:	e9 c6 fa ff ff       	jmp    80106a13 <alltraps>

80106f4d <vector16>:
.globl vector16
vector16:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $16
80106f4f:	6a 10                	push   $0x10
  jmp alltraps
80106f51:	e9 bd fa ff ff       	jmp    80106a13 <alltraps>

80106f56 <vector17>:
.globl vector17
vector17:
  pushl $17
80106f56:	6a 11                	push   $0x11
  jmp alltraps
80106f58:	e9 b6 fa ff ff       	jmp    80106a13 <alltraps>

80106f5d <vector18>:
.globl vector18
vector18:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $18
80106f5f:	6a 12                	push   $0x12
  jmp alltraps
80106f61:	e9 ad fa ff ff       	jmp    80106a13 <alltraps>

80106f66 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $19
80106f68:	6a 13                	push   $0x13
  jmp alltraps
80106f6a:	e9 a4 fa ff ff       	jmp    80106a13 <alltraps>

80106f6f <vector20>:
.globl vector20
vector20:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $20
80106f71:	6a 14                	push   $0x14
  jmp alltraps
80106f73:	e9 9b fa ff ff       	jmp    80106a13 <alltraps>

80106f78 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $21
80106f7a:	6a 15                	push   $0x15
  jmp alltraps
80106f7c:	e9 92 fa ff ff       	jmp    80106a13 <alltraps>

80106f81 <vector22>:
.globl vector22
vector22:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $22
80106f83:	6a 16                	push   $0x16
  jmp alltraps
80106f85:	e9 89 fa ff ff       	jmp    80106a13 <alltraps>

80106f8a <vector23>:
.globl vector23
vector23:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $23
80106f8c:	6a 17                	push   $0x17
  jmp alltraps
80106f8e:	e9 80 fa ff ff       	jmp    80106a13 <alltraps>

80106f93 <vector24>:
.globl vector24
vector24:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $24
80106f95:	6a 18                	push   $0x18
  jmp alltraps
80106f97:	e9 77 fa ff ff       	jmp    80106a13 <alltraps>

80106f9c <vector25>:
.globl vector25
vector25:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $25
80106f9e:	6a 19                	push   $0x19
  jmp alltraps
80106fa0:	e9 6e fa ff ff       	jmp    80106a13 <alltraps>

80106fa5 <vector26>:
.globl vector26
vector26:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $26
80106fa7:	6a 1a                	push   $0x1a
  jmp alltraps
80106fa9:	e9 65 fa ff ff       	jmp    80106a13 <alltraps>

80106fae <vector27>:
.globl vector27
vector27:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $27
80106fb0:	6a 1b                	push   $0x1b
  jmp alltraps
80106fb2:	e9 5c fa ff ff       	jmp    80106a13 <alltraps>

80106fb7 <vector28>:
.globl vector28
vector28:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $28
80106fb9:	6a 1c                	push   $0x1c
  jmp alltraps
80106fbb:	e9 53 fa ff ff       	jmp    80106a13 <alltraps>

80106fc0 <vector29>:
.globl vector29
vector29:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $29
80106fc2:	6a 1d                	push   $0x1d
  jmp alltraps
80106fc4:	e9 4a fa ff ff       	jmp    80106a13 <alltraps>

80106fc9 <vector30>:
.globl vector30
vector30:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $30
80106fcb:	6a 1e                	push   $0x1e
  jmp alltraps
80106fcd:	e9 41 fa ff ff       	jmp    80106a13 <alltraps>

80106fd2 <vector31>:
.globl vector31
vector31:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $31
80106fd4:	6a 1f                	push   $0x1f
  jmp alltraps
80106fd6:	e9 38 fa ff ff       	jmp    80106a13 <alltraps>

80106fdb <vector32>:
.globl vector32
vector32:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $32
80106fdd:	6a 20                	push   $0x20
  jmp alltraps
80106fdf:	e9 2f fa ff ff       	jmp    80106a13 <alltraps>

80106fe4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $33
80106fe6:	6a 21                	push   $0x21
  jmp alltraps
80106fe8:	e9 26 fa ff ff       	jmp    80106a13 <alltraps>

80106fed <vector34>:
.globl vector34
vector34:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $34
80106fef:	6a 22                	push   $0x22
  jmp alltraps
80106ff1:	e9 1d fa ff ff       	jmp    80106a13 <alltraps>

80106ff6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $35
80106ff8:	6a 23                	push   $0x23
  jmp alltraps
80106ffa:	e9 14 fa ff ff       	jmp    80106a13 <alltraps>

80106fff <vector36>:
.globl vector36
vector36:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $36
80107001:	6a 24                	push   $0x24
  jmp alltraps
80107003:	e9 0b fa ff ff       	jmp    80106a13 <alltraps>

80107008 <vector37>:
.globl vector37
vector37:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $37
8010700a:	6a 25                	push   $0x25
  jmp alltraps
8010700c:	e9 02 fa ff ff       	jmp    80106a13 <alltraps>

80107011 <vector38>:
.globl vector38
vector38:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $38
80107013:	6a 26                	push   $0x26
  jmp alltraps
80107015:	e9 f9 f9 ff ff       	jmp    80106a13 <alltraps>

8010701a <vector39>:
.globl vector39
vector39:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $39
8010701c:	6a 27                	push   $0x27
  jmp alltraps
8010701e:	e9 f0 f9 ff ff       	jmp    80106a13 <alltraps>

80107023 <vector40>:
.globl vector40
vector40:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $40
80107025:	6a 28                	push   $0x28
  jmp alltraps
80107027:	e9 e7 f9 ff ff       	jmp    80106a13 <alltraps>

8010702c <vector41>:
.globl vector41
vector41:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $41
8010702e:	6a 29                	push   $0x29
  jmp alltraps
80107030:	e9 de f9 ff ff       	jmp    80106a13 <alltraps>

80107035 <vector42>:
.globl vector42
vector42:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $42
80107037:	6a 2a                	push   $0x2a
  jmp alltraps
80107039:	e9 d5 f9 ff ff       	jmp    80106a13 <alltraps>

8010703e <vector43>:
.globl vector43
vector43:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $43
80107040:	6a 2b                	push   $0x2b
  jmp alltraps
80107042:	e9 cc f9 ff ff       	jmp    80106a13 <alltraps>

80107047 <vector44>:
.globl vector44
vector44:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $44
80107049:	6a 2c                	push   $0x2c
  jmp alltraps
8010704b:	e9 c3 f9 ff ff       	jmp    80106a13 <alltraps>

80107050 <vector45>:
.globl vector45
vector45:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $45
80107052:	6a 2d                	push   $0x2d
  jmp alltraps
80107054:	e9 ba f9 ff ff       	jmp    80106a13 <alltraps>

80107059 <vector46>:
.globl vector46
vector46:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $46
8010705b:	6a 2e                	push   $0x2e
  jmp alltraps
8010705d:	e9 b1 f9 ff ff       	jmp    80106a13 <alltraps>

80107062 <vector47>:
.globl vector47
vector47:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $47
80107064:	6a 2f                	push   $0x2f
  jmp alltraps
80107066:	e9 a8 f9 ff ff       	jmp    80106a13 <alltraps>

8010706b <vector48>:
.globl vector48
vector48:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $48
8010706d:	6a 30                	push   $0x30
  jmp alltraps
8010706f:	e9 9f f9 ff ff       	jmp    80106a13 <alltraps>

80107074 <vector49>:
.globl vector49
vector49:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $49
80107076:	6a 31                	push   $0x31
  jmp alltraps
80107078:	e9 96 f9 ff ff       	jmp    80106a13 <alltraps>

8010707d <vector50>:
.globl vector50
vector50:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $50
8010707f:	6a 32                	push   $0x32
  jmp alltraps
80107081:	e9 8d f9 ff ff       	jmp    80106a13 <alltraps>

80107086 <vector51>:
.globl vector51
vector51:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $51
80107088:	6a 33                	push   $0x33
  jmp alltraps
8010708a:	e9 84 f9 ff ff       	jmp    80106a13 <alltraps>

8010708f <vector52>:
.globl vector52
vector52:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $52
80107091:	6a 34                	push   $0x34
  jmp alltraps
80107093:	e9 7b f9 ff ff       	jmp    80106a13 <alltraps>

80107098 <vector53>:
.globl vector53
vector53:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $53
8010709a:	6a 35                	push   $0x35
  jmp alltraps
8010709c:	e9 72 f9 ff ff       	jmp    80106a13 <alltraps>

801070a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $54
801070a3:	6a 36                	push   $0x36
  jmp alltraps
801070a5:	e9 69 f9 ff ff       	jmp    80106a13 <alltraps>

801070aa <vector55>:
.globl vector55
vector55:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $55
801070ac:	6a 37                	push   $0x37
  jmp alltraps
801070ae:	e9 60 f9 ff ff       	jmp    80106a13 <alltraps>

801070b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $56
801070b5:	6a 38                	push   $0x38
  jmp alltraps
801070b7:	e9 57 f9 ff ff       	jmp    80106a13 <alltraps>

801070bc <vector57>:
.globl vector57
vector57:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $57
801070be:	6a 39                	push   $0x39
  jmp alltraps
801070c0:	e9 4e f9 ff ff       	jmp    80106a13 <alltraps>

801070c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $58
801070c7:	6a 3a                	push   $0x3a
  jmp alltraps
801070c9:	e9 45 f9 ff ff       	jmp    80106a13 <alltraps>

801070ce <vector59>:
.globl vector59
vector59:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $59
801070d0:	6a 3b                	push   $0x3b
  jmp alltraps
801070d2:	e9 3c f9 ff ff       	jmp    80106a13 <alltraps>

801070d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $60
801070d9:	6a 3c                	push   $0x3c
  jmp alltraps
801070db:	e9 33 f9 ff ff       	jmp    80106a13 <alltraps>

801070e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $61
801070e2:	6a 3d                	push   $0x3d
  jmp alltraps
801070e4:	e9 2a f9 ff ff       	jmp    80106a13 <alltraps>

801070e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $62
801070eb:	6a 3e                	push   $0x3e
  jmp alltraps
801070ed:	e9 21 f9 ff ff       	jmp    80106a13 <alltraps>

801070f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $63
801070f4:	6a 3f                	push   $0x3f
  jmp alltraps
801070f6:	e9 18 f9 ff ff       	jmp    80106a13 <alltraps>

801070fb <vector64>:
.globl vector64
vector64:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $64
801070fd:	6a 40                	push   $0x40
  jmp alltraps
801070ff:	e9 0f f9 ff ff       	jmp    80106a13 <alltraps>

80107104 <vector65>:
.globl vector65
vector65:
  pushl $0
80107104:	6a 00                	push   $0x0
  pushl $65
80107106:	6a 41                	push   $0x41
  jmp alltraps
80107108:	e9 06 f9 ff ff       	jmp    80106a13 <alltraps>

8010710d <vector66>:
.globl vector66
vector66:
  pushl $0
8010710d:	6a 00                	push   $0x0
  pushl $66
8010710f:	6a 42                	push   $0x42
  jmp alltraps
80107111:	e9 fd f8 ff ff       	jmp    80106a13 <alltraps>

80107116 <vector67>:
.globl vector67
vector67:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $67
80107118:	6a 43                	push   $0x43
  jmp alltraps
8010711a:	e9 f4 f8 ff ff       	jmp    80106a13 <alltraps>

8010711f <vector68>:
.globl vector68
vector68:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $68
80107121:	6a 44                	push   $0x44
  jmp alltraps
80107123:	e9 eb f8 ff ff       	jmp    80106a13 <alltraps>

80107128 <vector69>:
.globl vector69
vector69:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $69
8010712a:	6a 45                	push   $0x45
  jmp alltraps
8010712c:	e9 e2 f8 ff ff       	jmp    80106a13 <alltraps>

80107131 <vector70>:
.globl vector70
vector70:
  pushl $0
80107131:	6a 00                	push   $0x0
  pushl $70
80107133:	6a 46                	push   $0x46
  jmp alltraps
80107135:	e9 d9 f8 ff ff       	jmp    80106a13 <alltraps>

8010713a <vector71>:
.globl vector71
vector71:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $71
8010713c:	6a 47                	push   $0x47
  jmp alltraps
8010713e:	e9 d0 f8 ff ff       	jmp    80106a13 <alltraps>

80107143 <vector72>:
.globl vector72
vector72:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $72
80107145:	6a 48                	push   $0x48
  jmp alltraps
80107147:	e9 c7 f8 ff ff       	jmp    80106a13 <alltraps>

8010714c <vector73>:
.globl vector73
vector73:
  pushl $0
8010714c:	6a 00                	push   $0x0
  pushl $73
8010714e:	6a 49                	push   $0x49
  jmp alltraps
80107150:	e9 be f8 ff ff       	jmp    80106a13 <alltraps>

80107155 <vector74>:
.globl vector74
vector74:
  pushl $0
80107155:	6a 00                	push   $0x0
  pushl $74
80107157:	6a 4a                	push   $0x4a
  jmp alltraps
80107159:	e9 b5 f8 ff ff       	jmp    80106a13 <alltraps>

8010715e <vector75>:
.globl vector75
vector75:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $75
80107160:	6a 4b                	push   $0x4b
  jmp alltraps
80107162:	e9 ac f8 ff ff       	jmp    80106a13 <alltraps>

80107167 <vector76>:
.globl vector76
vector76:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $76
80107169:	6a 4c                	push   $0x4c
  jmp alltraps
8010716b:	e9 a3 f8 ff ff       	jmp    80106a13 <alltraps>

80107170 <vector77>:
.globl vector77
vector77:
  pushl $0
80107170:	6a 00                	push   $0x0
  pushl $77
80107172:	6a 4d                	push   $0x4d
  jmp alltraps
80107174:	e9 9a f8 ff ff       	jmp    80106a13 <alltraps>

80107179 <vector78>:
.globl vector78
vector78:
  pushl $0
80107179:	6a 00                	push   $0x0
  pushl $78
8010717b:	6a 4e                	push   $0x4e
  jmp alltraps
8010717d:	e9 91 f8 ff ff       	jmp    80106a13 <alltraps>

80107182 <vector79>:
.globl vector79
vector79:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $79
80107184:	6a 4f                	push   $0x4f
  jmp alltraps
80107186:	e9 88 f8 ff ff       	jmp    80106a13 <alltraps>

8010718b <vector80>:
.globl vector80
vector80:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $80
8010718d:	6a 50                	push   $0x50
  jmp alltraps
8010718f:	e9 7f f8 ff ff       	jmp    80106a13 <alltraps>

80107194 <vector81>:
.globl vector81
vector81:
  pushl $0
80107194:	6a 00                	push   $0x0
  pushl $81
80107196:	6a 51                	push   $0x51
  jmp alltraps
80107198:	e9 76 f8 ff ff       	jmp    80106a13 <alltraps>

8010719d <vector82>:
.globl vector82
vector82:
  pushl $0
8010719d:	6a 00                	push   $0x0
  pushl $82
8010719f:	6a 52                	push   $0x52
  jmp alltraps
801071a1:	e9 6d f8 ff ff       	jmp    80106a13 <alltraps>

801071a6 <vector83>:
.globl vector83
vector83:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $83
801071a8:	6a 53                	push   $0x53
  jmp alltraps
801071aa:	e9 64 f8 ff ff       	jmp    80106a13 <alltraps>

801071af <vector84>:
.globl vector84
vector84:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $84
801071b1:	6a 54                	push   $0x54
  jmp alltraps
801071b3:	e9 5b f8 ff ff       	jmp    80106a13 <alltraps>

801071b8 <vector85>:
.globl vector85
vector85:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $85
801071ba:	6a 55                	push   $0x55
  jmp alltraps
801071bc:	e9 52 f8 ff ff       	jmp    80106a13 <alltraps>

801071c1 <vector86>:
.globl vector86
vector86:
  pushl $0
801071c1:	6a 00                	push   $0x0
  pushl $86
801071c3:	6a 56                	push   $0x56
  jmp alltraps
801071c5:	e9 49 f8 ff ff       	jmp    80106a13 <alltraps>

801071ca <vector87>:
.globl vector87
vector87:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $87
801071cc:	6a 57                	push   $0x57
  jmp alltraps
801071ce:	e9 40 f8 ff ff       	jmp    80106a13 <alltraps>

801071d3 <vector88>:
.globl vector88
vector88:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $88
801071d5:	6a 58                	push   $0x58
  jmp alltraps
801071d7:	e9 37 f8 ff ff       	jmp    80106a13 <alltraps>

801071dc <vector89>:
.globl vector89
vector89:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $89
801071de:	6a 59                	push   $0x59
  jmp alltraps
801071e0:	e9 2e f8 ff ff       	jmp    80106a13 <alltraps>

801071e5 <vector90>:
.globl vector90
vector90:
  pushl $0
801071e5:	6a 00                	push   $0x0
  pushl $90
801071e7:	6a 5a                	push   $0x5a
  jmp alltraps
801071e9:	e9 25 f8 ff ff       	jmp    80106a13 <alltraps>

801071ee <vector91>:
.globl vector91
vector91:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $91
801071f0:	6a 5b                	push   $0x5b
  jmp alltraps
801071f2:	e9 1c f8 ff ff       	jmp    80106a13 <alltraps>

801071f7 <vector92>:
.globl vector92
vector92:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $92
801071f9:	6a 5c                	push   $0x5c
  jmp alltraps
801071fb:	e9 13 f8 ff ff       	jmp    80106a13 <alltraps>

80107200 <vector93>:
.globl vector93
vector93:
  pushl $0
80107200:	6a 00                	push   $0x0
  pushl $93
80107202:	6a 5d                	push   $0x5d
  jmp alltraps
80107204:	e9 0a f8 ff ff       	jmp    80106a13 <alltraps>

80107209 <vector94>:
.globl vector94
vector94:
  pushl $0
80107209:	6a 00                	push   $0x0
  pushl $94
8010720b:	6a 5e                	push   $0x5e
  jmp alltraps
8010720d:	e9 01 f8 ff ff       	jmp    80106a13 <alltraps>

80107212 <vector95>:
.globl vector95
vector95:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $95
80107214:	6a 5f                	push   $0x5f
  jmp alltraps
80107216:	e9 f8 f7 ff ff       	jmp    80106a13 <alltraps>

8010721b <vector96>:
.globl vector96
vector96:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $96
8010721d:	6a 60                	push   $0x60
  jmp alltraps
8010721f:	e9 ef f7 ff ff       	jmp    80106a13 <alltraps>

80107224 <vector97>:
.globl vector97
vector97:
  pushl $0
80107224:	6a 00                	push   $0x0
  pushl $97
80107226:	6a 61                	push   $0x61
  jmp alltraps
80107228:	e9 e6 f7 ff ff       	jmp    80106a13 <alltraps>

8010722d <vector98>:
.globl vector98
vector98:
  pushl $0
8010722d:	6a 00                	push   $0x0
  pushl $98
8010722f:	6a 62                	push   $0x62
  jmp alltraps
80107231:	e9 dd f7 ff ff       	jmp    80106a13 <alltraps>

80107236 <vector99>:
.globl vector99
vector99:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $99
80107238:	6a 63                	push   $0x63
  jmp alltraps
8010723a:	e9 d4 f7 ff ff       	jmp    80106a13 <alltraps>

8010723f <vector100>:
.globl vector100
vector100:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $100
80107241:	6a 64                	push   $0x64
  jmp alltraps
80107243:	e9 cb f7 ff ff       	jmp    80106a13 <alltraps>

80107248 <vector101>:
.globl vector101
vector101:
  pushl $0
80107248:	6a 00                	push   $0x0
  pushl $101
8010724a:	6a 65                	push   $0x65
  jmp alltraps
8010724c:	e9 c2 f7 ff ff       	jmp    80106a13 <alltraps>

80107251 <vector102>:
.globl vector102
vector102:
  pushl $0
80107251:	6a 00                	push   $0x0
  pushl $102
80107253:	6a 66                	push   $0x66
  jmp alltraps
80107255:	e9 b9 f7 ff ff       	jmp    80106a13 <alltraps>

8010725a <vector103>:
.globl vector103
vector103:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $103
8010725c:	6a 67                	push   $0x67
  jmp alltraps
8010725e:	e9 b0 f7 ff ff       	jmp    80106a13 <alltraps>

80107263 <vector104>:
.globl vector104
vector104:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $104
80107265:	6a 68                	push   $0x68
  jmp alltraps
80107267:	e9 a7 f7 ff ff       	jmp    80106a13 <alltraps>

8010726c <vector105>:
.globl vector105
vector105:
  pushl $0
8010726c:	6a 00                	push   $0x0
  pushl $105
8010726e:	6a 69                	push   $0x69
  jmp alltraps
80107270:	e9 9e f7 ff ff       	jmp    80106a13 <alltraps>

80107275 <vector106>:
.globl vector106
vector106:
  pushl $0
80107275:	6a 00                	push   $0x0
  pushl $106
80107277:	6a 6a                	push   $0x6a
  jmp alltraps
80107279:	e9 95 f7 ff ff       	jmp    80106a13 <alltraps>

8010727e <vector107>:
.globl vector107
vector107:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $107
80107280:	6a 6b                	push   $0x6b
  jmp alltraps
80107282:	e9 8c f7 ff ff       	jmp    80106a13 <alltraps>

80107287 <vector108>:
.globl vector108
vector108:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $108
80107289:	6a 6c                	push   $0x6c
  jmp alltraps
8010728b:	e9 83 f7 ff ff       	jmp    80106a13 <alltraps>

80107290 <vector109>:
.globl vector109
vector109:
  pushl $0
80107290:	6a 00                	push   $0x0
  pushl $109
80107292:	6a 6d                	push   $0x6d
  jmp alltraps
80107294:	e9 7a f7 ff ff       	jmp    80106a13 <alltraps>

80107299 <vector110>:
.globl vector110
vector110:
  pushl $0
80107299:	6a 00                	push   $0x0
  pushl $110
8010729b:	6a 6e                	push   $0x6e
  jmp alltraps
8010729d:	e9 71 f7 ff ff       	jmp    80106a13 <alltraps>

801072a2 <vector111>:
.globl vector111
vector111:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $111
801072a4:	6a 6f                	push   $0x6f
  jmp alltraps
801072a6:	e9 68 f7 ff ff       	jmp    80106a13 <alltraps>

801072ab <vector112>:
.globl vector112
vector112:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $112
801072ad:	6a 70                	push   $0x70
  jmp alltraps
801072af:	e9 5f f7 ff ff       	jmp    80106a13 <alltraps>

801072b4 <vector113>:
.globl vector113
vector113:
  pushl $0
801072b4:	6a 00                	push   $0x0
  pushl $113
801072b6:	6a 71                	push   $0x71
  jmp alltraps
801072b8:	e9 56 f7 ff ff       	jmp    80106a13 <alltraps>

801072bd <vector114>:
.globl vector114
vector114:
  pushl $0
801072bd:	6a 00                	push   $0x0
  pushl $114
801072bf:	6a 72                	push   $0x72
  jmp alltraps
801072c1:	e9 4d f7 ff ff       	jmp    80106a13 <alltraps>

801072c6 <vector115>:
.globl vector115
vector115:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $115
801072c8:	6a 73                	push   $0x73
  jmp alltraps
801072ca:	e9 44 f7 ff ff       	jmp    80106a13 <alltraps>

801072cf <vector116>:
.globl vector116
vector116:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $116
801072d1:	6a 74                	push   $0x74
  jmp alltraps
801072d3:	e9 3b f7 ff ff       	jmp    80106a13 <alltraps>

801072d8 <vector117>:
.globl vector117
vector117:
  pushl $0
801072d8:	6a 00                	push   $0x0
  pushl $117
801072da:	6a 75                	push   $0x75
  jmp alltraps
801072dc:	e9 32 f7 ff ff       	jmp    80106a13 <alltraps>

801072e1 <vector118>:
.globl vector118
vector118:
  pushl $0
801072e1:	6a 00                	push   $0x0
  pushl $118
801072e3:	6a 76                	push   $0x76
  jmp alltraps
801072e5:	e9 29 f7 ff ff       	jmp    80106a13 <alltraps>

801072ea <vector119>:
.globl vector119
vector119:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $119
801072ec:	6a 77                	push   $0x77
  jmp alltraps
801072ee:	e9 20 f7 ff ff       	jmp    80106a13 <alltraps>

801072f3 <vector120>:
.globl vector120
vector120:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $120
801072f5:	6a 78                	push   $0x78
  jmp alltraps
801072f7:	e9 17 f7 ff ff       	jmp    80106a13 <alltraps>

801072fc <vector121>:
.globl vector121
vector121:
  pushl $0
801072fc:	6a 00                	push   $0x0
  pushl $121
801072fe:	6a 79                	push   $0x79
  jmp alltraps
80107300:	e9 0e f7 ff ff       	jmp    80106a13 <alltraps>

80107305 <vector122>:
.globl vector122
vector122:
  pushl $0
80107305:	6a 00                	push   $0x0
  pushl $122
80107307:	6a 7a                	push   $0x7a
  jmp alltraps
80107309:	e9 05 f7 ff ff       	jmp    80106a13 <alltraps>

8010730e <vector123>:
.globl vector123
vector123:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $123
80107310:	6a 7b                	push   $0x7b
  jmp alltraps
80107312:	e9 fc f6 ff ff       	jmp    80106a13 <alltraps>

80107317 <vector124>:
.globl vector124
vector124:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $124
80107319:	6a 7c                	push   $0x7c
  jmp alltraps
8010731b:	e9 f3 f6 ff ff       	jmp    80106a13 <alltraps>

80107320 <vector125>:
.globl vector125
vector125:
  pushl $0
80107320:	6a 00                	push   $0x0
  pushl $125
80107322:	6a 7d                	push   $0x7d
  jmp alltraps
80107324:	e9 ea f6 ff ff       	jmp    80106a13 <alltraps>

80107329 <vector126>:
.globl vector126
vector126:
  pushl $0
80107329:	6a 00                	push   $0x0
  pushl $126
8010732b:	6a 7e                	push   $0x7e
  jmp alltraps
8010732d:	e9 e1 f6 ff ff       	jmp    80106a13 <alltraps>

80107332 <vector127>:
.globl vector127
vector127:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $127
80107334:	6a 7f                	push   $0x7f
  jmp alltraps
80107336:	e9 d8 f6 ff ff       	jmp    80106a13 <alltraps>

8010733b <vector128>:
.globl vector128
vector128:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $128
8010733d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107342:	e9 cc f6 ff ff       	jmp    80106a13 <alltraps>

80107347 <vector129>:
.globl vector129
vector129:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $129
80107349:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010734e:	e9 c0 f6 ff ff       	jmp    80106a13 <alltraps>

80107353 <vector130>:
.globl vector130
vector130:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $130
80107355:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010735a:	e9 b4 f6 ff ff       	jmp    80106a13 <alltraps>

8010735f <vector131>:
.globl vector131
vector131:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $131
80107361:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107366:	e9 a8 f6 ff ff       	jmp    80106a13 <alltraps>

8010736b <vector132>:
.globl vector132
vector132:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $132
8010736d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107372:	e9 9c f6 ff ff       	jmp    80106a13 <alltraps>

80107377 <vector133>:
.globl vector133
vector133:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $133
80107379:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010737e:	e9 90 f6 ff ff       	jmp    80106a13 <alltraps>

80107383 <vector134>:
.globl vector134
vector134:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $134
80107385:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010738a:	e9 84 f6 ff ff       	jmp    80106a13 <alltraps>

8010738f <vector135>:
.globl vector135
vector135:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $135
80107391:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107396:	e9 78 f6 ff ff       	jmp    80106a13 <alltraps>

8010739b <vector136>:
.globl vector136
vector136:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $136
8010739d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801073a2:	e9 6c f6 ff ff       	jmp    80106a13 <alltraps>

801073a7 <vector137>:
.globl vector137
vector137:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $137
801073a9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801073ae:	e9 60 f6 ff ff       	jmp    80106a13 <alltraps>

801073b3 <vector138>:
.globl vector138
vector138:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $138
801073b5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801073ba:	e9 54 f6 ff ff       	jmp    80106a13 <alltraps>

801073bf <vector139>:
.globl vector139
vector139:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $139
801073c1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801073c6:	e9 48 f6 ff ff       	jmp    80106a13 <alltraps>

801073cb <vector140>:
.globl vector140
vector140:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $140
801073cd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801073d2:	e9 3c f6 ff ff       	jmp    80106a13 <alltraps>

801073d7 <vector141>:
.globl vector141
vector141:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $141
801073d9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801073de:	e9 30 f6 ff ff       	jmp    80106a13 <alltraps>

801073e3 <vector142>:
.globl vector142
vector142:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $142
801073e5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801073ea:	e9 24 f6 ff ff       	jmp    80106a13 <alltraps>

801073ef <vector143>:
.globl vector143
vector143:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $143
801073f1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801073f6:	e9 18 f6 ff ff       	jmp    80106a13 <alltraps>

801073fb <vector144>:
.globl vector144
vector144:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $144
801073fd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107402:	e9 0c f6 ff ff       	jmp    80106a13 <alltraps>

80107407 <vector145>:
.globl vector145
vector145:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $145
80107409:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010740e:	e9 00 f6 ff ff       	jmp    80106a13 <alltraps>

80107413 <vector146>:
.globl vector146
vector146:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $146
80107415:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010741a:	e9 f4 f5 ff ff       	jmp    80106a13 <alltraps>

8010741f <vector147>:
.globl vector147
vector147:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $147
80107421:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107426:	e9 e8 f5 ff ff       	jmp    80106a13 <alltraps>

8010742b <vector148>:
.globl vector148
vector148:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $148
8010742d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107432:	e9 dc f5 ff ff       	jmp    80106a13 <alltraps>

80107437 <vector149>:
.globl vector149
vector149:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $149
80107439:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010743e:	e9 d0 f5 ff ff       	jmp    80106a13 <alltraps>

80107443 <vector150>:
.globl vector150
vector150:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $150
80107445:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010744a:	e9 c4 f5 ff ff       	jmp    80106a13 <alltraps>

8010744f <vector151>:
.globl vector151
vector151:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $151
80107451:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107456:	e9 b8 f5 ff ff       	jmp    80106a13 <alltraps>

8010745b <vector152>:
.globl vector152
vector152:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $152
8010745d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107462:	e9 ac f5 ff ff       	jmp    80106a13 <alltraps>

80107467 <vector153>:
.globl vector153
vector153:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $153
80107469:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010746e:	e9 a0 f5 ff ff       	jmp    80106a13 <alltraps>

80107473 <vector154>:
.globl vector154
vector154:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $154
80107475:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010747a:	e9 94 f5 ff ff       	jmp    80106a13 <alltraps>

8010747f <vector155>:
.globl vector155
vector155:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $155
80107481:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107486:	e9 88 f5 ff ff       	jmp    80106a13 <alltraps>

8010748b <vector156>:
.globl vector156
vector156:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $156
8010748d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107492:	e9 7c f5 ff ff       	jmp    80106a13 <alltraps>

80107497 <vector157>:
.globl vector157
vector157:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $157
80107499:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010749e:	e9 70 f5 ff ff       	jmp    80106a13 <alltraps>

801074a3 <vector158>:
.globl vector158
vector158:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $158
801074a5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801074aa:	e9 64 f5 ff ff       	jmp    80106a13 <alltraps>

801074af <vector159>:
.globl vector159
vector159:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $159
801074b1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801074b6:	e9 58 f5 ff ff       	jmp    80106a13 <alltraps>

801074bb <vector160>:
.globl vector160
vector160:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $160
801074bd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801074c2:	e9 4c f5 ff ff       	jmp    80106a13 <alltraps>

801074c7 <vector161>:
.globl vector161
vector161:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $161
801074c9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801074ce:	e9 40 f5 ff ff       	jmp    80106a13 <alltraps>

801074d3 <vector162>:
.globl vector162
vector162:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $162
801074d5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801074da:	e9 34 f5 ff ff       	jmp    80106a13 <alltraps>

801074df <vector163>:
.globl vector163
vector163:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $163
801074e1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801074e6:	e9 28 f5 ff ff       	jmp    80106a13 <alltraps>

801074eb <vector164>:
.globl vector164
vector164:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $164
801074ed:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801074f2:	e9 1c f5 ff ff       	jmp    80106a13 <alltraps>

801074f7 <vector165>:
.globl vector165
vector165:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $165
801074f9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801074fe:	e9 10 f5 ff ff       	jmp    80106a13 <alltraps>

80107503 <vector166>:
.globl vector166
vector166:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $166
80107505:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010750a:	e9 04 f5 ff ff       	jmp    80106a13 <alltraps>

8010750f <vector167>:
.globl vector167
vector167:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $167
80107511:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107516:	e9 f8 f4 ff ff       	jmp    80106a13 <alltraps>

8010751b <vector168>:
.globl vector168
vector168:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $168
8010751d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107522:	e9 ec f4 ff ff       	jmp    80106a13 <alltraps>

80107527 <vector169>:
.globl vector169
vector169:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $169
80107529:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010752e:	e9 e0 f4 ff ff       	jmp    80106a13 <alltraps>

80107533 <vector170>:
.globl vector170
vector170:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $170
80107535:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010753a:	e9 d4 f4 ff ff       	jmp    80106a13 <alltraps>

8010753f <vector171>:
.globl vector171
vector171:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $171
80107541:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107546:	e9 c8 f4 ff ff       	jmp    80106a13 <alltraps>

8010754b <vector172>:
.globl vector172
vector172:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $172
8010754d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107552:	e9 bc f4 ff ff       	jmp    80106a13 <alltraps>

80107557 <vector173>:
.globl vector173
vector173:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $173
80107559:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010755e:	e9 b0 f4 ff ff       	jmp    80106a13 <alltraps>

80107563 <vector174>:
.globl vector174
vector174:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $174
80107565:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010756a:	e9 a4 f4 ff ff       	jmp    80106a13 <alltraps>

8010756f <vector175>:
.globl vector175
vector175:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $175
80107571:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107576:	e9 98 f4 ff ff       	jmp    80106a13 <alltraps>

8010757b <vector176>:
.globl vector176
vector176:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $176
8010757d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107582:	e9 8c f4 ff ff       	jmp    80106a13 <alltraps>

80107587 <vector177>:
.globl vector177
vector177:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $177
80107589:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010758e:	e9 80 f4 ff ff       	jmp    80106a13 <alltraps>

80107593 <vector178>:
.globl vector178
vector178:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $178
80107595:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010759a:	e9 74 f4 ff ff       	jmp    80106a13 <alltraps>

8010759f <vector179>:
.globl vector179
vector179:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $179
801075a1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801075a6:	e9 68 f4 ff ff       	jmp    80106a13 <alltraps>

801075ab <vector180>:
.globl vector180
vector180:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $180
801075ad:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801075b2:	e9 5c f4 ff ff       	jmp    80106a13 <alltraps>

801075b7 <vector181>:
.globl vector181
vector181:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $181
801075b9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801075be:	e9 50 f4 ff ff       	jmp    80106a13 <alltraps>

801075c3 <vector182>:
.globl vector182
vector182:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $182
801075c5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801075ca:	e9 44 f4 ff ff       	jmp    80106a13 <alltraps>

801075cf <vector183>:
.globl vector183
vector183:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $183
801075d1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801075d6:	e9 38 f4 ff ff       	jmp    80106a13 <alltraps>

801075db <vector184>:
.globl vector184
vector184:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $184
801075dd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801075e2:	e9 2c f4 ff ff       	jmp    80106a13 <alltraps>

801075e7 <vector185>:
.globl vector185
vector185:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $185
801075e9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801075ee:	e9 20 f4 ff ff       	jmp    80106a13 <alltraps>

801075f3 <vector186>:
.globl vector186
vector186:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $186
801075f5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801075fa:	e9 14 f4 ff ff       	jmp    80106a13 <alltraps>

801075ff <vector187>:
.globl vector187
vector187:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $187
80107601:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107606:	e9 08 f4 ff ff       	jmp    80106a13 <alltraps>

8010760b <vector188>:
.globl vector188
vector188:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $188
8010760d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107612:	e9 fc f3 ff ff       	jmp    80106a13 <alltraps>

80107617 <vector189>:
.globl vector189
vector189:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $189
80107619:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010761e:	e9 f0 f3 ff ff       	jmp    80106a13 <alltraps>

80107623 <vector190>:
.globl vector190
vector190:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $190
80107625:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010762a:	e9 e4 f3 ff ff       	jmp    80106a13 <alltraps>

8010762f <vector191>:
.globl vector191
vector191:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $191
80107631:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107636:	e9 d8 f3 ff ff       	jmp    80106a13 <alltraps>

8010763b <vector192>:
.globl vector192
vector192:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $192
8010763d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107642:	e9 cc f3 ff ff       	jmp    80106a13 <alltraps>

80107647 <vector193>:
.globl vector193
vector193:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $193
80107649:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010764e:	e9 c0 f3 ff ff       	jmp    80106a13 <alltraps>

80107653 <vector194>:
.globl vector194
vector194:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $194
80107655:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010765a:	e9 b4 f3 ff ff       	jmp    80106a13 <alltraps>

8010765f <vector195>:
.globl vector195
vector195:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $195
80107661:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107666:	e9 a8 f3 ff ff       	jmp    80106a13 <alltraps>

8010766b <vector196>:
.globl vector196
vector196:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $196
8010766d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107672:	e9 9c f3 ff ff       	jmp    80106a13 <alltraps>

80107677 <vector197>:
.globl vector197
vector197:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $197
80107679:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010767e:	e9 90 f3 ff ff       	jmp    80106a13 <alltraps>

80107683 <vector198>:
.globl vector198
vector198:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $198
80107685:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010768a:	e9 84 f3 ff ff       	jmp    80106a13 <alltraps>

8010768f <vector199>:
.globl vector199
vector199:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $199
80107691:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107696:	e9 78 f3 ff ff       	jmp    80106a13 <alltraps>

8010769b <vector200>:
.globl vector200
vector200:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $200
8010769d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801076a2:	e9 6c f3 ff ff       	jmp    80106a13 <alltraps>

801076a7 <vector201>:
.globl vector201
vector201:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $201
801076a9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801076ae:	e9 60 f3 ff ff       	jmp    80106a13 <alltraps>

801076b3 <vector202>:
.globl vector202
vector202:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $202
801076b5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801076ba:	e9 54 f3 ff ff       	jmp    80106a13 <alltraps>

801076bf <vector203>:
.globl vector203
vector203:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $203
801076c1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801076c6:	e9 48 f3 ff ff       	jmp    80106a13 <alltraps>

801076cb <vector204>:
.globl vector204
vector204:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $204
801076cd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801076d2:	e9 3c f3 ff ff       	jmp    80106a13 <alltraps>

801076d7 <vector205>:
.globl vector205
vector205:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $205
801076d9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801076de:	e9 30 f3 ff ff       	jmp    80106a13 <alltraps>

801076e3 <vector206>:
.globl vector206
vector206:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $206
801076e5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801076ea:	e9 24 f3 ff ff       	jmp    80106a13 <alltraps>

801076ef <vector207>:
.globl vector207
vector207:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $207
801076f1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801076f6:	e9 18 f3 ff ff       	jmp    80106a13 <alltraps>

801076fb <vector208>:
.globl vector208
vector208:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $208
801076fd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107702:	e9 0c f3 ff ff       	jmp    80106a13 <alltraps>

80107707 <vector209>:
.globl vector209
vector209:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $209
80107709:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010770e:	e9 00 f3 ff ff       	jmp    80106a13 <alltraps>

80107713 <vector210>:
.globl vector210
vector210:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $210
80107715:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010771a:	e9 f4 f2 ff ff       	jmp    80106a13 <alltraps>

8010771f <vector211>:
.globl vector211
vector211:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $211
80107721:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107726:	e9 e8 f2 ff ff       	jmp    80106a13 <alltraps>

8010772b <vector212>:
.globl vector212
vector212:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $212
8010772d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107732:	e9 dc f2 ff ff       	jmp    80106a13 <alltraps>

80107737 <vector213>:
.globl vector213
vector213:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $213
80107739:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010773e:	e9 d0 f2 ff ff       	jmp    80106a13 <alltraps>

80107743 <vector214>:
.globl vector214
vector214:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $214
80107745:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010774a:	e9 c4 f2 ff ff       	jmp    80106a13 <alltraps>

8010774f <vector215>:
.globl vector215
vector215:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $215
80107751:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107756:	e9 b8 f2 ff ff       	jmp    80106a13 <alltraps>

8010775b <vector216>:
.globl vector216
vector216:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $216
8010775d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107762:	e9 ac f2 ff ff       	jmp    80106a13 <alltraps>

80107767 <vector217>:
.globl vector217
vector217:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $217
80107769:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010776e:	e9 a0 f2 ff ff       	jmp    80106a13 <alltraps>

80107773 <vector218>:
.globl vector218
vector218:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $218
80107775:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010777a:	e9 94 f2 ff ff       	jmp    80106a13 <alltraps>

8010777f <vector219>:
.globl vector219
vector219:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $219
80107781:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107786:	e9 88 f2 ff ff       	jmp    80106a13 <alltraps>

8010778b <vector220>:
.globl vector220
vector220:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $220
8010778d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107792:	e9 7c f2 ff ff       	jmp    80106a13 <alltraps>

80107797 <vector221>:
.globl vector221
vector221:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $221
80107799:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010779e:	e9 70 f2 ff ff       	jmp    80106a13 <alltraps>

801077a3 <vector222>:
.globl vector222
vector222:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $222
801077a5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801077aa:	e9 64 f2 ff ff       	jmp    80106a13 <alltraps>

801077af <vector223>:
.globl vector223
vector223:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $223
801077b1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801077b6:	e9 58 f2 ff ff       	jmp    80106a13 <alltraps>

801077bb <vector224>:
.globl vector224
vector224:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $224
801077bd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801077c2:	e9 4c f2 ff ff       	jmp    80106a13 <alltraps>

801077c7 <vector225>:
.globl vector225
vector225:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $225
801077c9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801077ce:	e9 40 f2 ff ff       	jmp    80106a13 <alltraps>

801077d3 <vector226>:
.globl vector226
vector226:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $226
801077d5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801077da:	e9 34 f2 ff ff       	jmp    80106a13 <alltraps>

801077df <vector227>:
.globl vector227
vector227:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $227
801077e1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801077e6:	e9 28 f2 ff ff       	jmp    80106a13 <alltraps>

801077eb <vector228>:
.globl vector228
vector228:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $228
801077ed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801077f2:	e9 1c f2 ff ff       	jmp    80106a13 <alltraps>

801077f7 <vector229>:
.globl vector229
vector229:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $229
801077f9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801077fe:	e9 10 f2 ff ff       	jmp    80106a13 <alltraps>

80107803 <vector230>:
.globl vector230
vector230:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $230
80107805:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010780a:	e9 04 f2 ff ff       	jmp    80106a13 <alltraps>

8010780f <vector231>:
.globl vector231
vector231:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $231
80107811:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107816:	e9 f8 f1 ff ff       	jmp    80106a13 <alltraps>

8010781b <vector232>:
.globl vector232
vector232:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $232
8010781d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107822:	e9 ec f1 ff ff       	jmp    80106a13 <alltraps>

80107827 <vector233>:
.globl vector233
vector233:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $233
80107829:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010782e:	e9 e0 f1 ff ff       	jmp    80106a13 <alltraps>

80107833 <vector234>:
.globl vector234
vector234:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $234
80107835:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010783a:	e9 d4 f1 ff ff       	jmp    80106a13 <alltraps>

8010783f <vector235>:
.globl vector235
vector235:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $235
80107841:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107846:	e9 c8 f1 ff ff       	jmp    80106a13 <alltraps>

8010784b <vector236>:
.globl vector236
vector236:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $236
8010784d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107852:	e9 bc f1 ff ff       	jmp    80106a13 <alltraps>

80107857 <vector237>:
.globl vector237
vector237:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $237
80107859:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010785e:	e9 b0 f1 ff ff       	jmp    80106a13 <alltraps>

80107863 <vector238>:
.globl vector238
vector238:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $238
80107865:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010786a:	e9 a4 f1 ff ff       	jmp    80106a13 <alltraps>

8010786f <vector239>:
.globl vector239
vector239:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $239
80107871:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107876:	e9 98 f1 ff ff       	jmp    80106a13 <alltraps>

8010787b <vector240>:
.globl vector240
vector240:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $240
8010787d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107882:	e9 8c f1 ff ff       	jmp    80106a13 <alltraps>

80107887 <vector241>:
.globl vector241
vector241:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $241
80107889:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010788e:	e9 80 f1 ff ff       	jmp    80106a13 <alltraps>

80107893 <vector242>:
.globl vector242
vector242:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $242
80107895:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010789a:	e9 74 f1 ff ff       	jmp    80106a13 <alltraps>

8010789f <vector243>:
.globl vector243
vector243:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $243
801078a1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801078a6:	e9 68 f1 ff ff       	jmp    80106a13 <alltraps>

801078ab <vector244>:
.globl vector244
vector244:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $244
801078ad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801078b2:	e9 5c f1 ff ff       	jmp    80106a13 <alltraps>

801078b7 <vector245>:
.globl vector245
vector245:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $245
801078b9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801078be:	e9 50 f1 ff ff       	jmp    80106a13 <alltraps>

801078c3 <vector246>:
.globl vector246
vector246:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $246
801078c5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801078ca:	e9 44 f1 ff ff       	jmp    80106a13 <alltraps>

801078cf <vector247>:
.globl vector247
vector247:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $247
801078d1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801078d6:	e9 38 f1 ff ff       	jmp    80106a13 <alltraps>

801078db <vector248>:
.globl vector248
vector248:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $248
801078dd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801078e2:	e9 2c f1 ff ff       	jmp    80106a13 <alltraps>

801078e7 <vector249>:
.globl vector249
vector249:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $249
801078e9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801078ee:	e9 20 f1 ff ff       	jmp    80106a13 <alltraps>

801078f3 <vector250>:
.globl vector250
vector250:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $250
801078f5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801078fa:	e9 14 f1 ff ff       	jmp    80106a13 <alltraps>

801078ff <vector251>:
.globl vector251
vector251:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $251
80107901:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107906:	e9 08 f1 ff ff       	jmp    80106a13 <alltraps>

8010790b <vector252>:
.globl vector252
vector252:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $252
8010790d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107912:	e9 fc f0 ff ff       	jmp    80106a13 <alltraps>

80107917 <vector253>:
.globl vector253
vector253:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $253
80107919:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010791e:	e9 f0 f0 ff ff       	jmp    80106a13 <alltraps>

80107923 <vector254>:
.globl vector254
vector254:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $254
80107925:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010792a:	e9 e4 f0 ff ff       	jmp    80106a13 <alltraps>

8010792f <vector255>:
.globl vector255
vector255:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $255
80107931:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107936:	e9 d8 f0 ff ff       	jmp    80106a13 <alltraps>
8010793b:	66 90                	xchg   %ax,%ax
8010793d:	66 90                	xchg   %ax,%ax
8010793f:	90                   	nop

80107940 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107947:	c1 ea 16             	shr    $0x16,%edx
{
8010794a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010794b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010794e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107951:	8b 1f                	mov    (%edi),%ebx
80107953:	f6 c3 01             	test   $0x1,%bl
80107956:	74 28                	je     80107980 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107958:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010795e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107964:	89 f0                	mov    %esi,%eax
}
80107966:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107969:	c1 e8 0a             	shr    $0xa,%eax
8010796c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107971:	01 d8                	add    %ebx,%eax
}
80107973:	5b                   	pop    %ebx
80107974:	5e                   	pop    %esi
80107975:	5f                   	pop    %edi
80107976:	5d                   	pop    %ebp
80107977:	c3                   	ret    
80107978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107980:	85 c9                	test   %ecx,%ecx
80107982:	74 2c                	je     801079b0 <walkpgdir+0x70>
80107984:	e8 b7 ac ff ff       	call   80102640 <kalloc>
80107989:	89 c3                	mov    %eax,%ebx
8010798b:	85 c0                	test   %eax,%eax
8010798d:	74 21                	je     801079b0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010798f:	83 ec 04             	sub    $0x4,%esp
80107992:	68 00 10 00 00       	push   $0x1000
80107997:	6a 00                	push   $0x0
80107999:	50                   	push   %eax
8010799a:	e8 01 dc ff ff       	call   801055a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010799f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079a5:	83 c4 10             	add    $0x10,%esp
801079a8:	83 c8 07             	or     $0x7,%eax
801079ab:	89 07                	mov    %eax,(%edi)
801079ad:	eb b5                	jmp    80107964 <walkpgdir+0x24>
801079af:	90                   	nop
}
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
801079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079c0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079c6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801079ca:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801079d0:	89 d6                	mov    %edx,%esi
{
801079d2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801079d3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801079d9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079df:	8b 45 08             	mov    0x8(%ebp),%eax
801079e2:	29 f0                	sub    %esi,%eax
801079e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079e7:	eb 1f                	jmp    80107a08 <mappages+0x48>
801079e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801079f0:	f6 00 01             	testb  $0x1,(%eax)
801079f3:	75 45                	jne    80107a3a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801079f5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801079f8:	83 cb 01             	or     $0x1,%ebx
801079fb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801079fd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107a00:	74 2e                	je     80107a30 <mappages+0x70>
      break;
    a += PGSIZE;
80107a02:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a0b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107a10:	89 f2                	mov    %esi,%edx
80107a12:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107a15:	89 f8                	mov    %edi,%eax
80107a17:	e8 24 ff ff ff       	call   80107940 <walkpgdir>
80107a1c:	85 c0                	test   %eax,%eax
80107a1e:	75 d0                	jne    801079f0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a28:	5b                   	pop    %ebx
80107a29:	5e                   	pop    %esi
80107a2a:	5f                   	pop    %edi
80107a2b:	5d                   	pop    %ebp
80107a2c:	c3                   	ret    
80107a2d:	8d 76 00             	lea    0x0(%esi),%esi
80107a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a33:	31 c0                	xor    %eax,%eax
}
80107a35:	5b                   	pop    %ebx
80107a36:	5e                   	pop    %esi
80107a37:	5f                   	pop    %edi
80107a38:	5d                   	pop    %ebp
80107a39:	c3                   	ret    
      panic("remap");
80107a3a:	83 ec 0c             	sub    $0xc,%esp
80107a3d:	68 88 8d 10 80       	push   $0x80108d88
80107a42:	e8 49 89 ff ff       	call   80100390 <panic>
80107a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a4e:	66 90                	xchg   %ax,%ax

80107a50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	89 c6                	mov    %eax,%esi
80107a57:	53                   	push   %ebx
80107a58:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107a5a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107a60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a66:	83 ec 1c             	sub    $0x1c,%esp
80107a69:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a6c:	39 da                	cmp    %ebx,%edx
80107a6e:	73 5b                	jae    80107acb <deallocuvm.part.0+0x7b>
80107a70:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107a73:	89 d7                	mov    %edx,%edi
80107a75:	eb 14                	jmp    80107a8b <deallocuvm.part.0+0x3b>
80107a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a7e:	66 90                	xchg   %ax,%ax
80107a80:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107a86:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107a89:	76 40                	jbe    80107acb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a8b:	31 c9                	xor    %ecx,%ecx
80107a8d:	89 fa                	mov    %edi,%edx
80107a8f:	89 f0                	mov    %esi,%eax
80107a91:	e8 aa fe ff ff       	call   80107940 <walkpgdir>
80107a96:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107a98:	85 c0                	test   %eax,%eax
80107a9a:	74 44                	je     80107ae0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107a9c:	8b 00                	mov    (%eax),%eax
80107a9e:	a8 01                	test   $0x1,%al
80107aa0:	74 de                	je     80107a80 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107aa7:	74 47                	je     80107af0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107aa9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107aac:	05 00 00 00 80       	add    $0x80000000,%eax
80107ab1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107ab7:	50                   	push   %eax
80107ab8:	e8 c3 a9 ff ff       	call   80102480 <kfree>
      *pte = 0;
80107abd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107ac3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107ac6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107ac9:	77 c0                	ja     80107a8b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad1:	5b                   	pop    %ebx
80107ad2:	5e                   	pop    %esi
80107ad3:	5f                   	pop    %edi
80107ad4:	5d                   	pop    %ebp
80107ad5:	c3                   	ret    
80107ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107add:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107ae0:	89 fa                	mov    %edi,%edx
80107ae2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107ae8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107aee:	eb 96                	jmp    80107a86 <deallocuvm.part.0+0x36>
        panic("kfree");
80107af0:	83 ec 0c             	sub    $0xc,%esp
80107af3:	68 e6 84 10 80       	push   $0x801084e6
80107af8:	e8 93 88 ff ff       	call   80100390 <panic>
80107afd:	8d 76 00             	lea    0x0(%esi),%esi

80107b00 <seginit>:
{
80107b00:	f3 0f 1e fb          	endbr32 
80107b04:	55                   	push   %ebp
80107b05:	89 e5                	mov    %esp,%ebp
80107b07:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107b0a:	e8 b1 be ff ff       	call   801039c0 <cpuid>
  pd[0] = size-1;
80107b0f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107b14:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107b1a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b1e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107b25:	ff 00 00 
80107b28:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80107b2f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107b32:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107b39:	ff 00 00 
80107b3c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107b43:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107b46:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107b4d:	ff 00 00 
80107b50:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107b57:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107b5a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107b61:	ff 00 00 
80107b64:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107b6b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107b6e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107b73:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107b77:	c1 e8 10             	shr    $0x10,%eax
80107b7a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b7e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107b81:	0f 01 10             	lgdtl  (%eax)
}
80107b84:	c9                   	leave  
80107b85:	c3                   	ret    
80107b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi

80107b90 <switchkvm>:
{
80107b90:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b94:	a1 a4 88 11 80       	mov    0x801188a4,%eax
80107b99:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b9e:	0f 22 d8             	mov    %eax,%cr3
}
80107ba1:	c3                   	ret    
80107ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bb0 <switchuvm>:
{
80107bb0:	f3 0f 1e fb          	endbr32 
80107bb4:	55                   	push   %ebp
80107bb5:	89 e5                	mov    %esp,%ebp
80107bb7:	57                   	push   %edi
80107bb8:	56                   	push   %esi
80107bb9:	53                   	push   %ebx
80107bba:	83 ec 1c             	sub    $0x1c,%esp
80107bbd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107bc0:	85 f6                	test   %esi,%esi
80107bc2:	0f 84 cb 00 00 00    	je     80107c93 <switchuvm+0xe3>
  if(p->kstack == 0)
80107bc8:	8b 46 08             	mov    0x8(%esi),%eax
80107bcb:	85 c0                	test   %eax,%eax
80107bcd:	0f 84 da 00 00 00    	je     80107cad <switchuvm+0xfd>
  if(p->pgdir == 0)
80107bd3:	8b 46 04             	mov    0x4(%esi),%eax
80107bd6:	85 c0                	test   %eax,%eax
80107bd8:	0f 84 c2 00 00 00    	je     80107ca0 <switchuvm+0xf0>
  pushcli();
80107bde:	e8 ad d7 ff ff       	call   80105390 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107be3:	e8 68 bd ff ff       	call   80103950 <mycpu>
80107be8:	89 c3                	mov    %eax,%ebx
80107bea:	e8 61 bd ff ff       	call   80103950 <mycpu>
80107bef:	89 c7                	mov    %eax,%edi
80107bf1:	e8 5a bd ff ff       	call   80103950 <mycpu>
80107bf6:	83 c7 08             	add    $0x8,%edi
80107bf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bfc:	e8 4f bd ff ff       	call   80103950 <mycpu>
80107c01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c04:	ba 67 00 00 00       	mov    $0x67,%edx
80107c09:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107c10:	83 c0 08             	add    $0x8,%eax
80107c13:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c1a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c1f:	83 c1 08             	add    $0x8,%ecx
80107c22:	c1 e8 18             	shr    $0x18,%eax
80107c25:	c1 e9 10             	shr    $0x10,%ecx
80107c28:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107c2e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107c34:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107c39:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107c40:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107c45:	e8 06 bd ff ff       	call   80103950 <mycpu>
80107c4a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107c51:	e8 fa bc ff ff       	call   80103950 <mycpu>
80107c56:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107c5a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107c5d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c63:	e8 e8 bc ff ff       	call   80103950 <mycpu>
80107c68:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c6b:	e8 e0 bc ff ff       	call   80103950 <mycpu>
80107c70:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107c74:	b8 28 00 00 00       	mov    $0x28,%eax
80107c79:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107c7c:	8b 46 04             	mov    0x4(%esi),%eax
80107c7f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c84:	0f 22 d8             	mov    %eax,%cr3
}
80107c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c8a:	5b                   	pop    %ebx
80107c8b:	5e                   	pop    %esi
80107c8c:	5f                   	pop    %edi
80107c8d:	5d                   	pop    %ebp
  popcli();
80107c8e:	e9 4d d7 ff ff       	jmp    801053e0 <popcli>
    panic("switchuvm: no process");
80107c93:	83 ec 0c             	sub    $0xc,%esp
80107c96:	68 8e 8d 10 80       	push   $0x80108d8e
80107c9b:	e8 f0 86 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107ca0:	83 ec 0c             	sub    $0xc,%esp
80107ca3:	68 b9 8d 10 80       	push   $0x80108db9
80107ca8:	e8 e3 86 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107cad:	83 ec 0c             	sub    $0xc,%esp
80107cb0:	68 a4 8d 10 80       	push   $0x80108da4
80107cb5:	e8 d6 86 ff ff       	call   80100390 <panic>
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cc0 <inituvm>:
{
80107cc0:	f3 0f 1e fb          	endbr32 
80107cc4:	55                   	push   %ebp
80107cc5:	89 e5                	mov    %esp,%ebp
80107cc7:	57                   	push   %edi
80107cc8:	56                   	push   %esi
80107cc9:	53                   	push   %ebx
80107cca:	83 ec 1c             	sub    $0x1c,%esp
80107ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd0:	8b 75 10             	mov    0x10(%ebp),%esi
80107cd3:	8b 7d 08             	mov    0x8(%ebp),%edi
80107cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107cd9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107cdf:	77 4b                	ja     80107d2c <inituvm+0x6c>
  mem = kalloc();
80107ce1:	e8 5a a9 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80107ce6:	83 ec 04             	sub    $0x4,%esp
80107ce9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107cee:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107cf0:	6a 00                	push   $0x0
80107cf2:	50                   	push   %eax
80107cf3:	e8 a8 d8 ff ff       	call   801055a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107cf8:	58                   	pop    %eax
80107cf9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107cff:	5a                   	pop    %edx
80107d00:	6a 06                	push   $0x6
80107d02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d07:	31 d2                	xor    %edx,%edx
80107d09:	50                   	push   %eax
80107d0a:	89 f8                	mov    %edi,%eax
80107d0c:	e8 af fc ff ff       	call   801079c0 <mappages>
  memmove(mem, init, sz);
80107d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d14:	89 75 10             	mov    %esi,0x10(%ebp)
80107d17:	83 c4 10             	add    $0x10,%esp
80107d1a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107d1d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d23:	5b                   	pop    %ebx
80107d24:	5e                   	pop    %esi
80107d25:	5f                   	pop    %edi
80107d26:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107d27:	e9 14 d9 ff ff       	jmp    80105640 <memmove>
    panic("inituvm: more than a page");
80107d2c:	83 ec 0c             	sub    $0xc,%esp
80107d2f:	68 cd 8d 10 80       	push   $0x80108dcd
80107d34:	e8 57 86 ff ff       	call   80100390 <panic>
80107d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d40 <loaduvm>:
{
80107d40:	f3 0f 1e fb          	endbr32 
80107d44:	55                   	push   %ebp
80107d45:	89 e5                	mov    %esp,%ebp
80107d47:	57                   	push   %edi
80107d48:	56                   	push   %esi
80107d49:	53                   	push   %ebx
80107d4a:	83 ec 1c             	sub    $0x1c,%esp
80107d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d50:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107d53:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107d58:	0f 85 99 00 00 00    	jne    80107df7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80107d5e:	01 f0                	add    %esi,%eax
80107d60:	89 f3                	mov    %esi,%ebx
80107d62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d65:	8b 45 14             	mov    0x14(%ebp),%eax
80107d68:	01 f0                	add    %esi,%eax
80107d6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107d6d:	85 f6                	test   %esi,%esi
80107d6f:	75 15                	jne    80107d86 <loaduvm+0x46>
80107d71:	eb 6d                	jmp    80107de0 <loaduvm+0xa0>
80107d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d77:	90                   	nop
80107d78:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107d7e:	89 f0                	mov    %esi,%eax
80107d80:	29 d8                	sub    %ebx,%eax
80107d82:	39 c6                	cmp    %eax,%esi
80107d84:	76 5a                	jbe    80107de0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d89:	8b 45 08             	mov    0x8(%ebp),%eax
80107d8c:	31 c9                	xor    %ecx,%ecx
80107d8e:	29 da                	sub    %ebx,%edx
80107d90:	e8 ab fb ff ff       	call   80107940 <walkpgdir>
80107d95:	85 c0                	test   %eax,%eax
80107d97:	74 51                	je     80107dea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107d99:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d9b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107d9e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107da8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107dae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107db1:	29 d9                	sub    %ebx,%ecx
80107db3:	05 00 00 00 80       	add    $0x80000000,%eax
80107db8:	57                   	push   %edi
80107db9:	51                   	push   %ecx
80107dba:	50                   	push   %eax
80107dbb:	ff 75 10             	pushl  0x10(%ebp)
80107dbe:	e8 ad 9c ff ff       	call   80101a70 <readi>
80107dc3:	83 c4 10             	add    $0x10,%esp
80107dc6:	39 f8                	cmp    %edi,%eax
80107dc8:	74 ae                	je     80107d78 <loaduvm+0x38>
}
80107dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107dd2:	5b                   	pop    %ebx
80107dd3:	5e                   	pop    %esi
80107dd4:	5f                   	pop    %edi
80107dd5:	5d                   	pop    %ebp
80107dd6:	c3                   	ret    
80107dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dde:	66 90                	xchg   %ax,%ax
80107de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107de3:	31 c0                	xor    %eax,%eax
}
80107de5:	5b                   	pop    %ebx
80107de6:	5e                   	pop    %esi
80107de7:	5f                   	pop    %edi
80107de8:	5d                   	pop    %ebp
80107de9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107dea:	83 ec 0c             	sub    $0xc,%esp
80107ded:	68 e7 8d 10 80       	push   $0x80108de7
80107df2:	e8 99 85 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107df7:	83 ec 0c             	sub    $0xc,%esp
80107dfa:	68 88 8e 10 80       	push   $0x80108e88
80107dff:	e8 8c 85 ff ff       	call   80100390 <panic>
80107e04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e0f:	90                   	nop

80107e10 <allocuvm>:
{
80107e10:	f3 0f 1e fb          	endbr32 
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	57                   	push   %edi
80107e18:	56                   	push   %esi
80107e19:	53                   	push   %ebx
80107e1a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107e1d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107e20:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e26:	85 c0                	test   %eax,%eax
80107e28:	0f 88 b2 00 00 00    	js     80107ee0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107e2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107e34:	0f 82 96 00 00 00    	jb     80107ed0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107e3a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107e40:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107e46:	39 75 10             	cmp    %esi,0x10(%ebp)
80107e49:	77 40                	ja     80107e8b <allocuvm+0x7b>
80107e4b:	e9 83 00 00 00       	jmp    80107ed3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107e50:	83 ec 04             	sub    $0x4,%esp
80107e53:	68 00 10 00 00       	push   $0x1000
80107e58:	6a 00                	push   $0x0
80107e5a:	50                   	push   %eax
80107e5b:	e8 40 d7 ff ff       	call   801055a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107e60:	58                   	pop    %eax
80107e61:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e67:	5a                   	pop    %edx
80107e68:	6a 06                	push   $0x6
80107e6a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e6f:	89 f2                	mov    %esi,%edx
80107e71:	50                   	push   %eax
80107e72:	89 f8                	mov    %edi,%eax
80107e74:	e8 47 fb ff ff       	call   801079c0 <mappages>
80107e79:	83 c4 10             	add    $0x10,%esp
80107e7c:	85 c0                	test   %eax,%eax
80107e7e:	78 78                	js     80107ef8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107e80:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e86:	39 75 10             	cmp    %esi,0x10(%ebp)
80107e89:	76 48                	jbe    80107ed3 <allocuvm+0xc3>
    mem = kalloc();
80107e8b:	e8 b0 a7 ff ff       	call   80102640 <kalloc>
80107e90:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107e92:	85 c0                	test   %eax,%eax
80107e94:	75 ba                	jne    80107e50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107e96:	83 ec 0c             	sub    $0xc,%esp
80107e99:	68 05 8e 10 80       	push   $0x80108e05
80107e9e:	e8 0d 88 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ea6:	83 c4 10             	add    $0x10,%esp
80107ea9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107eac:	74 32                	je     80107ee0 <allocuvm+0xd0>
80107eae:	8b 55 10             	mov    0x10(%ebp),%edx
80107eb1:	89 c1                	mov    %eax,%ecx
80107eb3:	89 f8                	mov    %edi,%eax
80107eb5:	e8 96 fb ff ff       	call   80107a50 <deallocuvm.part.0>
      return 0;
80107eba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ec7:	5b                   	pop    %ebx
80107ec8:	5e                   	pop    %esi
80107ec9:	5f                   	pop    %edi
80107eca:	5d                   	pop    %ebp
80107ecb:	c3                   	ret    
80107ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ed9:	5b                   	pop    %ebx
80107eda:	5e                   	pop    %esi
80107edb:	5f                   	pop    %edi
80107edc:	5d                   	pop    %ebp
80107edd:	c3                   	ret    
80107ede:	66 90                	xchg   %ax,%ax
    return 0;
80107ee0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eed:	5b                   	pop    %ebx
80107eee:	5e                   	pop    %esi
80107eef:	5f                   	pop    %edi
80107ef0:	5d                   	pop    %ebp
80107ef1:	c3                   	ret    
80107ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107ef8:	83 ec 0c             	sub    $0xc,%esp
80107efb:	68 1d 8e 10 80       	push   $0x80108e1d
80107f00:	e8 ab 87 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107f05:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f08:	83 c4 10             	add    $0x10,%esp
80107f0b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f0e:	74 0c                	je     80107f1c <allocuvm+0x10c>
80107f10:	8b 55 10             	mov    0x10(%ebp),%edx
80107f13:	89 c1                	mov    %eax,%ecx
80107f15:	89 f8                	mov    %edi,%eax
80107f17:	e8 34 fb ff ff       	call   80107a50 <deallocuvm.part.0>
      kfree(mem);
80107f1c:	83 ec 0c             	sub    $0xc,%esp
80107f1f:	53                   	push   %ebx
80107f20:	e8 5b a5 ff ff       	call   80102480 <kfree>
      return 0;
80107f25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107f2c:	83 c4 10             	add    $0x10,%esp
}
80107f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f35:	5b                   	pop    %ebx
80107f36:	5e                   	pop    %esi
80107f37:	5f                   	pop    %edi
80107f38:	5d                   	pop    %ebp
80107f39:	c3                   	ret    
80107f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f40 <deallocuvm>:
{
80107f40:	f3 0f 1e fb          	endbr32 
80107f44:	55                   	push   %ebp
80107f45:	89 e5                	mov    %esp,%ebp
80107f47:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107f50:	39 d1                	cmp    %edx,%ecx
80107f52:	73 0c                	jae    80107f60 <deallocuvm+0x20>
}
80107f54:	5d                   	pop    %ebp
80107f55:	e9 f6 fa ff ff       	jmp    80107a50 <deallocuvm.part.0>
80107f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f60:	89 d0                	mov    %edx,%eax
80107f62:	5d                   	pop    %ebp
80107f63:	c3                   	ret    
80107f64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f6f:	90                   	nop

80107f70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f70:	f3 0f 1e fb          	endbr32 
80107f74:	55                   	push   %ebp
80107f75:	89 e5                	mov    %esp,%ebp
80107f77:	57                   	push   %edi
80107f78:	56                   	push   %esi
80107f79:	53                   	push   %ebx
80107f7a:	83 ec 0c             	sub    $0xc,%esp
80107f7d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107f80:	85 f6                	test   %esi,%esi
80107f82:	74 55                	je     80107fd9 <freevm+0x69>
  if(newsz >= oldsz)
80107f84:	31 c9                	xor    %ecx,%ecx
80107f86:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107f8b:	89 f0                	mov    %esi,%eax
80107f8d:	89 f3                	mov    %esi,%ebx
80107f8f:	e8 bc fa ff ff       	call   80107a50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f94:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107f9a:	eb 0b                	jmp    80107fa7 <freevm+0x37>
80107f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fa0:	83 c3 04             	add    $0x4,%ebx
80107fa3:	39 df                	cmp    %ebx,%edi
80107fa5:	74 23                	je     80107fca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107fa7:	8b 03                	mov    (%ebx),%eax
80107fa9:	a8 01                	test   $0x1,%al
80107fab:	74 f3                	je     80107fa0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107fad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107fb2:	83 ec 0c             	sub    $0xc,%esp
80107fb5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107fb8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107fbd:	50                   	push   %eax
80107fbe:	e8 bd a4 ff ff       	call   80102480 <kfree>
80107fc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107fc6:	39 df                	cmp    %ebx,%edi
80107fc8:	75 dd                	jne    80107fa7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107fca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fd0:	5b                   	pop    %ebx
80107fd1:	5e                   	pop    %esi
80107fd2:	5f                   	pop    %edi
80107fd3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107fd4:	e9 a7 a4 ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107fd9:	83 ec 0c             	sub    $0xc,%esp
80107fdc:	68 39 8e 10 80       	push   $0x80108e39
80107fe1:	e8 aa 83 ff ff       	call   80100390 <panic>
80107fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fed:	8d 76 00             	lea    0x0(%esi),%esi

80107ff0 <setupkvm>:
{
80107ff0:	f3 0f 1e fb          	endbr32 
80107ff4:	55                   	push   %ebp
80107ff5:	89 e5                	mov    %esp,%ebp
80107ff7:	56                   	push   %esi
80107ff8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ff9:	e8 42 a6 ff ff       	call   80102640 <kalloc>
80107ffe:	89 c6                	mov    %eax,%esi
80108000:	85 c0                	test   %eax,%eax
80108002:	74 42                	je     80108046 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108004:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108007:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010800c:	68 00 10 00 00       	push   $0x1000
80108011:	6a 00                	push   $0x0
80108013:	50                   	push   %eax
80108014:	e8 87 d5 ff ff       	call   801055a0 <memset>
80108019:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010801c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010801f:	83 ec 08             	sub    $0x8,%esp
80108022:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108025:	ff 73 0c             	pushl  0xc(%ebx)
80108028:	8b 13                	mov    (%ebx),%edx
8010802a:	50                   	push   %eax
8010802b:	29 c1                	sub    %eax,%ecx
8010802d:	89 f0                	mov    %esi,%eax
8010802f:	e8 8c f9 ff ff       	call   801079c0 <mappages>
80108034:	83 c4 10             	add    $0x10,%esp
80108037:	85 c0                	test   %eax,%eax
80108039:	78 15                	js     80108050 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010803b:	83 c3 10             	add    $0x10,%ebx
8010803e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80108044:	75 d6                	jne    8010801c <setupkvm+0x2c>
}
80108046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108049:	89 f0                	mov    %esi,%eax
8010804b:	5b                   	pop    %ebx
8010804c:	5e                   	pop    %esi
8010804d:	5d                   	pop    %ebp
8010804e:	c3                   	ret    
8010804f:	90                   	nop
      freevm(pgdir);
80108050:	83 ec 0c             	sub    $0xc,%esp
80108053:	56                   	push   %esi
      return 0;
80108054:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108056:	e8 15 ff ff ff       	call   80107f70 <freevm>
      return 0;
8010805b:	83 c4 10             	add    $0x10,%esp
}
8010805e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108061:	89 f0                	mov    %esi,%eax
80108063:	5b                   	pop    %ebx
80108064:	5e                   	pop    %esi
80108065:	5d                   	pop    %ebp
80108066:	c3                   	ret    
80108067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010806e:	66 90                	xchg   %ax,%ax

80108070 <kvmalloc>:
{
80108070:	f3 0f 1e fb          	endbr32 
80108074:	55                   	push   %ebp
80108075:	89 e5                	mov    %esp,%ebp
80108077:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010807a:	e8 71 ff ff ff       	call   80107ff0 <setupkvm>
8010807f:	a3 a4 88 11 80       	mov    %eax,0x801188a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108084:	05 00 00 00 80       	add    $0x80000000,%eax
80108089:	0f 22 d8             	mov    %eax,%cr3
}
8010808c:	c9                   	leave  
8010808d:	c3                   	ret    
8010808e:	66 90                	xchg   %ax,%ax

80108090 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108090:	f3 0f 1e fb          	endbr32 
80108094:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108095:	31 c9                	xor    %ecx,%ecx
{
80108097:	89 e5                	mov    %esp,%ebp
80108099:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010809c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010809f:	8b 45 08             	mov    0x8(%ebp),%eax
801080a2:	e8 99 f8 ff ff       	call   80107940 <walkpgdir>
  if(pte == 0)
801080a7:	85 c0                	test   %eax,%eax
801080a9:	74 05                	je     801080b0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801080ab:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801080ae:	c9                   	leave  
801080af:	c3                   	ret    
    panic("clearpteu");
801080b0:	83 ec 0c             	sub    $0xc,%esp
801080b3:	68 4a 8e 10 80       	push   $0x80108e4a
801080b8:	e8 d3 82 ff ff       	call   80100390 <panic>
801080bd:	8d 76 00             	lea    0x0(%esi),%esi

801080c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801080c0:	f3 0f 1e fb          	endbr32 
801080c4:	55                   	push   %ebp
801080c5:	89 e5                	mov    %esp,%ebp
801080c7:	57                   	push   %edi
801080c8:	56                   	push   %esi
801080c9:	53                   	push   %ebx
801080ca:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801080cd:	e8 1e ff ff ff       	call   80107ff0 <setupkvm>
801080d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080d5:	85 c0                	test   %eax,%eax
801080d7:	0f 84 9b 00 00 00    	je     80108178 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801080dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801080e0:	85 c9                	test   %ecx,%ecx
801080e2:	0f 84 90 00 00 00    	je     80108178 <copyuvm+0xb8>
801080e8:	31 f6                	xor    %esi,%esi
801080ea:	eb 46                	jmp    80108132 <copyuvm+0x72>
801080ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801080f0:	83 ec 04             	sub    $0x4,%esp
801080f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801080f9:	68 00 10 00 00       	push   $0x1000
801080fe:	57                   	push   %edi
801080ff:	50                   	push   %eax
80108100:	e8 3b d5 ff ff       	call   80105640 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108105:	58                   	pop    %eax
80108106:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010810c:	5a                   	pop    %edx
8010810d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108110:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108115:	89 f2                	mov    %esi,%edx
80108117:	50                   	push   %eax
80108118:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010811b:	e8 a0 f8 ff ff       	call   801079c0 <mappages>
80108120:	83 c4 10             	add    $0x10,%esp
80108123:	85 c0                	test   %eax,%eax
80108125:	78 61                	js     80108188 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108127:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010812d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108130:	76 46                	jbe    80108178 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108132:	8b 45 08             	mov    0x8(%ebp),%eax
80108135:	31 c9                	xor    %ecx,%ecx
80108137:	89 f2                	mov    %esi,%edx
80108139:	e8 02 f8 ff ff       	call   80107940 <walkpgdir>
8010813e:	85 c0                	test   %eax,%eax
80108140:	74 61                	je     801081a3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108142:	8b 00                	mov    (%eax),%eax
80108144:	a8 01                	test   $0x1,%al
80108146:	74 4e                	je     80108196 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108148:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010814a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010814f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108152:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108158:	e8 e3 a4 ff ff       	call   80102640 <kalloc>
8010815d:	89 c3                	mov    %eax,%ebx
8010815f:	85 c0                	test   %eax,%eax
80108161:	75 8d                	jne    801080f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108163:	83 ec 0c             	sub    $0xc,%esp
80108166:	ff 75 e0             	pushl  -0x20(%ebp)
80108169:	e8 02 fe ff ff       	call   80107f70 <freevm>
  return 0;
8010816e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108175:	83 c4 10             	add    $0x10,%esp
}
80108178:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010817b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010817e:	5b                   	pop    %ebx
8010817f:	5e                   	pop    %esi
80108180:	5f                   	pop    %edi
80108181:	5d                   	pop    %ebp
80108182:	c3                   	ret    
80108183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108187:	90                   	nop
      kfree(mem);
80108188:	83 ec 0c             	sub    $0xc,%esp
8010818b:	53                   	push   %ebx
8010818c:	e8 ef a2 ff ff       	call   80102480 <kfree>
      goto bad;
80108191:	83 c4 10             	add    $0x10,%esp
80108194:	eb cd                	jmp    80108163 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108196:	83 ec 0c             	sub    $0xc,%esp
80108199:	68 6e 8e 10 80       	push   $0x80108e6e
8010819e:	e8 ed 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801081a3:	83 ec 0c             	sub    $0xc,%esp
801081a6:	68 54 8e 10 80       	push   $0x80108e54
801081ab:	e8 e0 81 ff ff       	call   80100390 <panic>

801081b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081b0:	f3 0f 1e fb          	endbr32 
801081b4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081b5:	31 c9                	xor    %ecx,%ecx
{
801081b7:	89 e5                	mov    %esp,%ebp
801081b9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801081bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801081bf:	8b 45 08             	mov    0x8(%ebp),%eax
801081c2:	e8 79 f7 ff ff       	call   80107940 <walkpgdir>
  if((*pte & PTE_P) == 0)
801081c7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801081c9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801081ca:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801081d1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081d4:	05 00 00 00 80       	add    $0x80000000,%eax
801081d9:	83 fa 05             	cmp    $0x5,%edx
801081dc:	ba 00 00 00 00       	mov    $0x0,%edx
801081e1:	0f 45 c2             	cmovne %edx,%eax
}
801081e4:	c3                   	ret    
801081e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801081f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081f0:	f3 0f 1e fb          	endbr32 
801081f4:	55                   	push   %ebp
801081f5:	89 e5                	mov    %esp,%ebp
801081f7:	57                   	push   %edi
801081f8:	56                   	push   %esi
801081f9:	53                   	push   %ebx
801081fa:	83 ec 0c             	sub    $0xc,%esp
801081fd:	8b 75 14             	mov    0x14(%ebp),%esi
80108200:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108203:	85 f6                	test   %esi,%esi
80108205:	75 3c                	jne    80108243 <copyout+0x53>
80108207:	eb 67                	jmp    80108270 <copyout+0x80>
80108209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108210:	8b 55 0c             	mov    0xc(%ebp),%edx
80108213:	89 fb                	mov    %edi,%ebx
80108215:	29 d3                	sub    %edx,%ebx
80108217:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010821d:	39 f3                	cmp    %esi,%ebx
8010821f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108222:	29 fa                	sub    %edi,%edx
80108224:	83 ec 04             	sub    $0x4,%esp
80108227:	01 c2                	add    %eax,%edx
80108229:	53                   	push   %ebx
8010822a:	ff 75 10             	pushl  0x10(%ebp)
8010822d:	52                   	push   %edx
8010822e:	e8 0d d4 ff ff       	call   80105640 <memmove>
    len -= n;
    buf += n;
80108233:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108236:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010823c:	83 c4 10             	add    $0x10,%esp
8010823f:	29 de                	sub    %ebx,%esi
80108241:	74 2d                	je     80108270 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108243:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108245:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108248:	89 55 0c             	mov    %edx,0xc(%ebp)
8010824b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108251:	57                   	push   %edi
80108252:	ff 75 08             	pushl  0x8(%ebp)
80108255:	e8 56 ff ff ff       	call   801081b0 <uva2ka>
    if(pa0 == 0)
8010825a:	83 c4 10             	add    $0x10,%esp
8010825d:	85 c0                	test   %eax,%eax
8010825f:	75 af                	jne    80108210 <copyout+0x20>
  }
  return 0;
}
80108261:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108269:	5b                   	pop    %ebx
8010826a:	5e                   	pop    %esi
8010826b:	5f                   	pop    %edi
8010826c:	5d                   	pop    %ebp
8010826d:	c3                   	ret    
8010826e:	66 90                	xchg   %ax,%ax
80108270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108273:	31 c0                	xor    %eax,%eax
}
80108275:	5b                   	pop    %ebx
80108276:	5e                   	pop    %esi
80108277:	5f                   	pop    %edi
80108278:	5d                   	pop    %ebp
80108279:	c3                   	ret    
