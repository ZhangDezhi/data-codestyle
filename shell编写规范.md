# shell 编写规范

## 1. 开头

### 指明解释器
> 需要标明 解释器 以及文件编码

例如:
```bash
#！bin/sh
# 脚本
# 
```

查看本机支持的解释器
```bash
$ cat /etc/shells
#/etc/shells: valid login shells
/bin/sh
/bin/dash
/bin/bash
/bin/rbash
/usr/bin/screen
```


## 注释

## 参数

## 变量

### 开头定义
> 一般情况下我们会将一些重要的环境变量定义在开头，确保这些变量的存在。

```sh
#！bin/sh
source /etc/profile
export PATH=”/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/apps/bin/” 
```

### 双引号
勤用"" 
使用”$”来获取变量的时候最好加上双引号。不加上双引号在很多情况下都会造成很大的麻烦
例如: 
```sh
!/bin/sh
#已知当前文件夹有一个a.sh的文件
var="*.sh"
echo $var
echo "$var" 
```
执行结果 

```
a.sh
*.sh 
```

### 作用域
> 相比直接使用全局变量，我们最好使用local readonly这类的命令，其次我们可以使用declare来声明变量。这些方式都比使用全局方式定义要好。 

巧用heredocs
　　所谓heredocs，也可以算是一种多行输入的方法，即在”<<”后定一个标识符，接着我们可以输入多行内容，直到再次遇到标识符为止。 
使用heredocs，我们可以非常方便的生成一些模板文件

```sh
cat>>/etc/rsyncd.conf <<EOF
log file = /usr/local/logs/rsyncd.log
transfer logging = yes
log format = %t %a %m %f %b
syslog facility = local3
EOF 
```

### 路径

> 不要直接使用 pwd 获得路径(不严谨)

推荐下面方法
```sh
script_dir=$(cd $(dirname $0) && pwd)
script_dir=$(dirname $(readlink -f $0 )) 
```




## 缩进
> 使用4个空格代替 \t

## 命名

## 编码
> 在写脚本的时候尽量使用UTF-8编码，能够支持中文等一些奇奇怪怪的字符。不过虽然能写中文，但是在写注释以及打log的时候还是尽量英文，毕竟很多机器还是没有直接支持中文的，打出来可能会有乱码。

## 密码
> 　不要把密码硬编码在脚本里，不要把密码硬编码在脚本里，不要把密码硬编码在脚本里。

## 换行
> 在调用某些程序的时候，参数可能会很长，这时候为了保证较好的阅读体验，我们可以用反斜杠来分行
主要:  在反斜杠前有个空格。

```sh
./configure \
–prefix=/usr \
–sbin-path=/usr/sbin/nginx \
–conf-path=/etc/nginx/nginx.conf \
```

## 函数
> 像java，C这样的编译型语言都会有一个函数入口，这种结构使得代码可读性很强，我们知道哪些直接执行，那些是函数。但是脚本不一样，脚本属于解释性语言，从第一行直接执行到最后一行，如果在这当中命令与函数糅杂在一起，那就非常难读了。
> 类似的main函数，使得脚本的结构化程度更好。

例如: 

```sh
#!/usr/bin/env bash
func1(){
    #do sth
}
func2(){
    #do sth
}
main(){
    func1
    func2
}
main "$@" 

```

## 尽量简短代码

里的简短不单单是指代码长度，而是只用到的命令数。原则上我们应当做到，能一条命令解决的问题绝不用两条命令解决。这不仅牵涉到代码的可读性，而且也关乎代码的执行效率。 

例如:
```sh
cat /etc/passwd | grep root   #不推荐
grep root /etc/passwd         #推荐
```

## 

> #尽量使用func( ){ }来定义函数，而不是func{ }
> #尽量使用[[ ]]来代替[ ]
> #尽量使用\$()将命令的结果赋给变量，而不是反引号在复杂的场景下尽量使用# 
> #printf代替echo进行回显

## tips

> #1.路径尽量保持绝对路径，不容易出错，如果非要用相对路径，最好用./修饰
> #2.优先使用bash的变量替换代替awk sed，这样更加简短
> #3.简单的if尽量使用&& ||，写成单行。比如[[ x > 2]] && echo x
> #4.当export变量时，尽量加上子脚本的namespace，保证变量不冲突
> #5.会使用trap捕获信号，并在接受到终止信号时执行一些收尾工作
> #6.使用mktemp生成临时文件或文件夹
> #7.利用/dev/null过滤不友好的输出信息
> #8.会利用命令的返回值判断命令的执行情况
> #9.使用文件前要判断文件是否存在，否则做好异常处理
> #10.不要处理ls后的数据(比如ls -l | awk '{ print $8 }')，ls的结果非常不确定，并且平台有关
> #11.读取文件时不要使用for loop而要使用while read


# 静态检查工具


https://github.com/koalaman/shellcheck
提供了一个非常非常强大的wiki。在这个wiki里，我们可以找到这个工具所有判断的依据。在这里，每一个检测到的问题都可以在wiki里找到对应的问题单号，他不仅告诉我们”这样写不好”，而且告诉我们”为什么这样写不好”

