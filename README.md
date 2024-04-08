# minitalk
project to learn how server and client communicate by making small client and server programs and exchanging information between those.
<br/><br/>
## Key Concept
### Sending Information in binary
To send information from client to server, information should be converted into bits and `SIGUSR1`(for 0) and `SIGUSR2`(for 1) signals will be sent.<br/>
1. I want to send `A`(ascii value 65)
2. 65 = 1000001<sub>2</sub>, and `SIGUSR2` `SIGUSR1` `SIGUSR1` `SIGUSR1` `SIGUSR1` `SIGUSR1` `SIGUSR2` will be sent accordingly from client to server, and server prints `A` out.

### Signal
A **Signal** is a standardized notification message used in Unix and POSIX-compliant operating systems.

Each `SIGNAL` has an integer value. You can see the values the table in the [Link](https://de.wikipedia.org/wiki/Signal_(Unix)).

For each process, the kernel maintains two bit vectors: **pending**, to monitor pending signals, and **blocked**, to keep track of the blocked signals. When it sends a signal, the kernel simply sets the appropriate bit to 1 in the destination process’ pending bit vector.[^note]

[^note]: [Sending and Intercepting a Signal in C](https://www.codequoi.com/en/sending-and-intercepting-a-signal-in-c/)

**Sending Signal**: changing bits in pending signal set

**Receiving Signal**: kernel chooses a signal (typically the smallest) in unblocked pending signal set and forces the process to react to it with an action.
<br/>
Receiving can be either: 
 * ignore the signal, 
 * terminate the execution, 
 * intercept the signal by executing its own handler in response (*the case in this project*)

POSIX-compatible operating systems use these signals.
**POSIX** : a family of standards specified by the IEEE Computer Society for maintaining compatibility between operating systems.

A process receiving a signal will perform one of these actions:
 * **Terminate**
 * **Core** : terminates and makes core dump
 * **Ignore**
 * **Stop** : stops till the process receives SIGCONT signal
<br/>

### Process Groups
Each process belongs to a group which is identified by a positive integer, the PGID (process group identifier). It’s an easy way to recognize related processes. 
* PID(Process ID), PPID(Parents' process ID, pid of another process which initialized the process), PGID(Proccess Group ID, representing a process group during its lifetime)

`ps -ef | head` standing for process status, shows informations about running processes.
<br/><br/>

### Kill
To send signals to the terminal, `kill` can be used. `kill -l` shows all the possible signals.
<br/><br/>

### Sigaction
To intercept the signal and do something else than default action. `SIGKILL` and `SIGSTOP` cannot be intercepted.
sigaction is the name of a function as well as of data structure.
```c
int sigaction(
  int    signum,
  const  struct sigaction *_Nullable restrict act,
  struct sigaction *_Nullable restrict oldact
);
```
sigaction function:

* **signum** the number of signal and can be any signal except `SIGKILL` and `SIGSTOP`
* **act**: pointer to sigaction-type structure. 
* **oldact**: pointer to sigaction-type structure for old action upon receipt of signal if we need it.

returns 0 when success otherwise -1

```c
struct sigaction
{
    void     (*sa_handler)(int);   
    void     (*sa_sigaction)(int, siginfo_t *, void *);
    sigset_t sa_mask;
    int      sa_flags;
    void     (*sa_restorer)(void);
}
```
sigaction struct:
* **sa_handler**: the function to execute when the designated signal comes in. `SIG_DFL` for default action, `SIG_IGN` for ignore. Or should be a pointer to `void function_name(int signal)`.
* **sa_mask**: a bit array that includes the signals that we want to block.
* **sa_flags**: different options to change the detail of action.
<br/><br/>

### Unicode 
**Unicode** is an international encoding standard for use with different languages and scripts, by which each letter, digit, or symbol is assigned a unique numeric value that applies across different platforms and programs. 
Unicode use 21-bits system, which means it can store 2<sup>21</sup> different letters, emojis. But actual Range is 0x0 ~ 0x10FFFF(1,114,111 in dec), since it seems to be a big  number enough to store symbols of our planet.
</br>Unicode has many encoding system, and UTF-8 is the most prevailed encoding system. Size from UTF-8 encoding varies from 1byte to 4byte. Below is the example of UTF-8 Converting System.<br/>
I will take a Korean letter `ㄱ` as an example. If I convert `ㄱ` to binary, the result is `11100011 10000100 10110001`([converter](https://onlinetools.com/unicode/convert-unicode-to-binary)). The very first `1110` means that the letter `ㄱ` is 3 bytes. and from second piece we should write `10` in front of following bits.
So the `ㄱ` is saved in unicode  `(1110)0011 (10)000100 (1011)0001` which menas `ㄱ` is stored in  `0 0000 0011 0001 0011 0001` (which is 0x3131). So when you send the signal `11100011 10000100 10110001(227 132 177 in dec.)` server will print `ㄱ`.
<br/>

Below is how to read the starting byte(the most left byte)

0xxxxxxx : if the byte starts with 0, the byte refers to ASCII value.<br/>
110xxxxx 10xxxxxx :  read till second byte and convert to a symbol.<br/>
1110xxxx 10xxxxxx 10xxxxxx : read till third byte and convert to a symbol.<br/>
11110xxx 10xxxxxx 10xxxxxx 10xxxxxx :  read till fourth byte and convert to a symbol.<br/>

## Key Function
```c
signal(SIGNAL, void (*)(int))
```

if `SIGNAL` is accepted, `void (*)(int)` will be executed
<br/><br/>
```c
int kill(pid_t pid, int sig)
```

send `int sig` to the process with process id `pid_t pid`. When `pid` is:

 * a positive integer: a process ID
 * a negative integer: a process group's ID
 * 0 : all process in the calling process' group
 * -1: all of the processes in the system (except process 1, init!) for which the calling process has the permission to send signals to
<br/><br/>

## Difficulties
* I tried to send data bit by bit through a loop from client. But it didn't work as I expected. Solution is to give a delay between signals in client.
* Emojis, or Non-latin Alphabets e.g. Korean Alphabets... You should know about Unicode and UTF-8 Encoding.
<br/><br/>
## Good To Know
[C function: signal](https://www.tutorialspoint.com/c_standard_library/c_function_signal.htm)

[Linux Sigaction System Call Programming(Youtube)](https://www.youtube.com/watch?v=_1TuZUbCnX0&list=PLjHp4dbhioyl_3VKPpuFNNtNz-WzplkwA)

[Sending and Intercepting a Signal in C](https://www.codequoi.com/en/sending-and-intercepting-a-signal-in-c/)

[Blog from a Student in 42 Seoul(in Korean)](https://velog.io/@kurtyoon/42-Minitalk)

[C programming: How can I program for Unicode](https://stackoverflow.com/questions/526430/c-programming-how-can-i-program-for-unicode)

[Emoji Unicode](https://unicode.org/emoji/charts/full-emoji-list.html)
