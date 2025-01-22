+++
title = "Tempted by the Tux"
date = "2025-01-21"
description = "I feel like macOS is getting noticeably worse with every single update. What about Linux, should I switch?"

[taxonomies]
tags = ["Linux", "macOS"]
+++

Years, no, decades, ago. Back in the time that Windows XP was state-of-the-art. I was annoyed with the instability of Windows on my PC[^1].

I had never known any other operating system. Sure, we had Windows 98SE before, and 95 before that. I had *heard* of Windows NT and 2000, but I was blissfully unaware of anything outside of Microsoft.

So I started researching. Initially just to find a potential silver bullet that would help, but instead of that I stumbled onto Linux. It seemed fascinating, but also very unknown and *scary*.

Until I found out about [Ubuntu](https://ubuntu.com/). For Ubuntu, you could order a CD, for free. The CD would allow you to run Ubuntu directly from the CD, installing to try it out was optional.

That seemed less scary, so I called their bluff, and ordered a bunch of the CD's. To my surprise, they actually arrived. No strings attached.

I installed Ubuntu, and I made it my primary operating system for years to come.

Initially, I had it set up as a dual boot with Windows, so I would have an escape hatch.

Later I decided to keep Windows only for playing games. Which also meant I could play around with creating custom Windows installers, with basically everything I thought of as optional removed. Which in my mind increased performance for the games.

As I started playing games less and less, and I got the most important ones to run on Ubuntu[^2], I eventually said goodbye to Windows (and Microsoft) entirely.

It was finicky, but I enjoyed it. Ubuntu served me well for years.

I was a fanboy. I recommended it to everybody, and I gave out the CD's to whoever would accept them. I reinstalled a part of the computers on campus to run Ubuntu, and I even transitioned by grandfather onto Linux (I was the one doing tech support anyway, so why not.).

When I got my first real job, with the associated first actual income, I started looking around for what to do with all that money.

I remembered my transition from Windows to Ubuntu, and how good it's been for me. And I got interested in the world of Apple.

What's not to like? It's still Unix, but with a wealthy commercial company developing it. This must be the best of both worlds.

So I caved. I got myself a state-of-the-art Mac Mini, running the latest and greatest: Mac OS X, Tiger.

Money well spent. It was great. And I haven't looked back in a long time. I didn't even dual boot for this transition!

I've owned pretty much every type of Mac over the years. Mac Mini, Mac Pro, MacBook Pro, MacBook Air. All have been good.

But lately.. I've started looking around again. I've tried a [Hackintosh](https://en.wikipedia.org/wiki/Hackintosh) when Apple's hardware didn't meet my requirements, but since the M1 the hardware is no longer the problem.

The hardware is pretty great now. Overpriced, but good quality.

The software is becoming more and more of a concern. I feel like macOS is getting noticeably worse with every single update.

For example:
- Used to be able to do `CMD`+`first-letter-of-the-primary-button`, whenever a dialog popped up, to "click" the button. Now, it doesn't work most of the time.
- Used to be able to press `Z`, and go to the last file in the current folder in Finder (regardless of the filename). They broke it, so it would only jump to whatever filename started with 'Z'.
- Got this annoying "external monitor" thing in the toolbar now, with no official way to hide it. Permanently fucking purple, as if it demands my immediate attention. ![External monitor indicator in toolbar for macOS Sequoia](/external-monitor.png)
- Widgets in the notification center will randomly decide to remove themselves.
- Give permission, re-give permission, so many alerts "ARE YOU SURE!?"
- And even after you've given permission, randomly the app will start complaining that it can't work any more because of missing permissions, while the permissions are still configured correctly according to the system settings. You then have to remove the permissions, to re-add them.
- I can't have [Colemak-DH](https://colemakmods.github.io/mod-dh/) as my only keyboard layout. Other keyboard layouts are allowed to be the only option, but in the case of Colemak-DH I'm forced to have another one in the list as well.
- Which wouldn't be too bad, if macOS didn't randomly decide to switch the active keyboard layout. It can even switch mid-sentence, really screwing with my appeared competency as a typist.
- It used to be possible to manually set a preference for which Wi-Fi to connect to, give them a priority. Now it just uses whichever one you used last, even if the better option is within range.
- External LAN ports were broken for a while. Forcing me to use Wi-Fi even if a (better) wired connection was available. 

Sometimes Apple comes back to fix it later, so it feels like they're skimping out on doing QA. And sometimes I get the impression that people like me simply aren't their target audience any more. Both of which make me sad. 

So… I've been looking around. 

I don't need anything bleeding edge, I prefer stability. So something like [Debian](https://www.debian.org/) would be great, and aligns with the vague familiarity I might still have from my Ubuntu days. Or [NixOS](https://nixos.org/), which introduces a bit of a learning curve but a very interesting concept that pretty much guarantees that I will have a bootable system no matter. 

Sadly, Apple has managed to lock me in a bit. I'm using the M1 MacBook Pro, which isn't supported very well outside of macOS.

I currently don't have the budget to get me a new machine. Especially since I know myself, and if I do decide to switch, I need to wow myself. If the system is slow and unresponsive, it's a bad impression, and not a fair comparison of the day-to-day experience. Which means that using a Raspberry Pi as a desktop computer is probably not going to cut it. 

So dual boot would be my best bet, and the most fair of a comparison. That basically leaves only [Asahi Linux](https://asahilinux.org/). 

Asahi looks promising, but unfinished. They've not managed to reverse engineer all the hardware yet. I can live without Touch ID, and the microphone, but USB-C Display is kind of a must-have for actually using it daily. 

So that leaves me… Stuck… Tempted by the Tux, but not quite able to switch at this time. 

I'll keep an eye on it, and maybe someday…

What about you? What are you running? Are you happy with it, or ready to jump ship?

[^1]: To be fair, it might have been at least partially caused by me. I did tend to mess with settings I didn't understand, and edit values in the registery just to see what would happen.

[^2]: The main one I played was "[Wolfenstein: Enemy Territory](https://www.splashdamage.com/games/wolfenstein-enemy-territory/)", which actually supported Linux. For the others [Wine](https://www.winehq.org/) was quite impressive.

