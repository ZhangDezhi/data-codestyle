# shell 编写规范
参考:
1. https://zh-google-styleguide.readthedocs.io/en/latest/google-shell-styleguide/contents/

[toc]

> Bash是唯一被允许执行的shell脚本语言。
> 如果你在乎性能，那么请选择其他工具，而不是使用shell。
> 如果你将要编写的脚本会超过100行，那么你可能应该使用Python来编写，而不是Shell


## 1. 基本环境

### 编码
> 在写脚本的时候尽量使用UTF-8编码，能够支持中文等一些奇奇怪怪的字符。不过虽然能写中文，但是在写注释以及打log的时候还是尽量英文，毕竟很多机器还是没有直接支持中文的，打出来可能会有乱码。
### 扩展名  

> 可执行文件应该没有扩展名（强烈建议）或者使用.sh扩展名。


### 密码
> 不要把密码硬编码在脚本里，不要把密码硬编码在脚本里，不要把密码硬编码在脚本里。

### 打印日志
> 所有的错误信息都应该被导向STDERR。
```bash
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

if ! do_something; then
    err "Unable to do_something"
    exit "${E_DID_NOTHING}"
fi
```
## 2. 注释
### 开头注释
> 需要标明 解释器 以及文件编码 

例如:
```bash
#!/bin/bash
# 脚本说明
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
### 功能注释
> 任何不是既明显又短的函数都必须被注释。任何库函数无论其长短和复杂性都必须被注释。
> 其他人通过阅读注释（和帮助信息，如果有的话）就能够学会如何使用你的程序或库函数，而不需要阅读代码。




### 实现部份注释
> 注释你代码中含有技巧、不明显、有趣的或者重要的部分。

### TODO注释
> 使用TODO注释临时的、短期解决方案的、或者足够好但不够完美的代码。
> 大写的字符串TODO，接着是括号中你的用户名。冒号是可选的。最好在TODO条目之后加上 bug或者ticket 的序号。
例如
```bash
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)
```
## 3. 格式

### 缩进 

> 缩进2个空格，没有制表符(\t)。
### 行长度限制
> 行的最大长度为80个字符。可以用反斜杠来分行(注意在反斜杠前有个空格)

例如:
```bash
./configure \
–prefix=/usr \
–sbin-path=/usr/sbin/nginx \
–conf-path=/etc/nginx/nginx.conf \
```
### 管道
> 如果一行容不下整个管道操作，那么请将整个管道操作分割成每行一个管段。

例如:

```bash
# All fits on one line
command1 | command2

# Long commands
command1 \
  | command2 \
  | command3 \
  | command4
```
### 循环
> 请将 ; do , ; then 和 while , for , if 放在同一行。

例如:

```bash
for dir in ${dirs_to_cleanup}; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  fi
done
```

### case语句

> 通过2个空格缩进可选项。
> 在同一行可选项的模式右圆括号之后和结束符 ;; 之前各需要一个空格。
> 长可选项或者多命令可选项应该被拆分成多行，模式、操作和结束符 ;; 在不同的行。


```bash
## 匹配表达式比 case 和 esac 缩进一级。多行操作要再缩进一级。
case "${expression}" in
  a)
    variable="..."
    some_command "${variable}" "${other_expr}" ...
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" ...
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac

## 只要整个表达式可读，简单的命令可以跟模式和 ;; 写在同一行。

verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```

### 变量扩展
> 按优先级顺序：保持跟你所发现的一致；引用你的变量；推荐用 ${var} 而不是 $var

```bash

# Section of recommended cases.

# Preferred style for 'special' variables:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..."

# Braces necessary:
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred style for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read f; do
  echo "file=${f}"
done < <(ls -l /tmp)

# Section of discouraged cases

# Unquoted vars, unbraced vars, brace-quoted single letter
# shell specials.
echo a=$avar "b=$bvar" "PID=${$}" "${1}"

# Confusing use: this is expanded as "${1}0${2}0${3}0",
# not "${10}${20}${30}
set -- a b c
echo "$10$20$30
```


### 引用
> 除非需要小心不带引用的扩展，否则总是引用包含变量、命令替换符、空格或shell元字符的字符串。
> 推荐引用是单词的字符串（而不是命令选项或者路径名）。
> 千万不要引用整数。
> 注意 [[ 中模式匹配的引用规则。
> 请使用 $@ 除非你有特殊原因需要使用 $*

例如:
```bash

# 'Single' quotes indicate that no substitution is desired.
# "Double" quotes indicate that substitution is required/tolerated.

# Simple examples
# "quote command substitutions"
flag="$(some_command and its args "$@" 'quoted separately')"

# "quote variables"
echo "${flag}"

# "never quote literal integers"
value=32
# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory
readonly USE_INTEGER='true'

# "quote shell meta characters"
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# "command options or path names"
# ($1 is assumed to contain a value here)
grep -li Hugo /dev/null "$1"

# Less simple examples
# "quote variables, unless proven false": ccs might be empty
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# Positional parameter precautions: $1 might be unset
# Single quotes leave regex as-is.
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# For passing on arguments,
# "$@" is right almost everytime, and
# $* is wrong almost everytime:
#
# * $* and $@ will split on spaces, clobbering up arguments
#   that contain spaces and dropping empty strings;
# * "$@" will retain arguments as-is, so no args
#   provided will result in no args being passed on;
#   This is in most cases what you want to use for passing
#   on arguments.
# * "$*" expands to one argument, with all args joined
#   by (usually) spaces,
#   so no args provided will result in one empty string
#   being passed on.
# (Consult 'man bash' for the nit-grits ;-)

set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$*"; echo "$#, $@")
set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$@"; echo "$#, $@")
```


### 函数
> 像java，C这样的编译型语言都会有一个函数入口，这种结构使得代码可读性很强，我们知道哪些直接执行，那些是函数。但是脚本不一样，脚本属于解释性语言，从第一行直接执行到最后一行，如果在这当中命令与函数糅杂在一起，那就非常难读了。
> 类似的main函数，使得脚本的结构化程度更好。
> > #尽量使用func( ){ }来定义函数，而不是func{ }
> #尽量使用[[ ]]来代替[ ]
> #尽量使用\$()将命令的结果赋给变量，而不是反引号在复杂的场景下尽量使用# 
> #printf代替echo进行回显


例如: 

```bash
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

## 4. 特性及错误

### 命令替换

> 使用 $(command) 而不是反引号。

例如:
```bash

# This is preferred:
var="$(command "$(command1)")"

# This is not:
var="`command \`command1\``"
```

### test，[和[[

> 推荐使用 [[ ... ]] ，而不是 [ , test , 和 /usr/bin/ [ 。

例如
```bash
# This ensures the string on the left is made up of characters in the
# alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
# For the gory details, see
# E14 at http://tiswww.case.edu/php/chet/bash/FAQ
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
  echo "Match"
fi

# This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory
if [ "filename" == f* ]; then
  echo "Match"
fi
```
### 测试字符串
> 尽可能使用引用，而不是过滤字符串。

例如:
```bash

# Do this:
if [[ "${my_var}" = "some_string" ]]; then
  do_something
fi

# -z (string length is zero) and -n (string length is not zero) are
# preferred over testing for an empty string
if [[ -z "${my_var}" ]]; then
  do_something
fi

# This is OK (ensure quotes on the empty side), but not preferred:
if [[ "${my_var}" = "" ]]; then
  do_something
fi

# Not this:
if [[ "${my_var}X" = "some_stringX" ]]; then
  do_something
fi
```



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






## 命名规范
### 函数名
> 使用小写字母，并用下划线分隔单词。使用双冒号 :: 分隔库。函数名之后必须有圆括号。关键词 function 是可选的，但必须在一个项目中保持一致。

例如:

```bash
# Single function
my_func() {
  ...
}

# Part of a package
mypackage::my_func() {
  ...
}
```

### 变量名
> 循环的变量名应该和循环的任何变量同样命名。

```bash
for zone in ${zones}; do
  something_with "${zone}"
done
```

### 常量和环境变量名
> 全部大写，用下划线分隔，声明在文件的顶部。

例如:
```bash
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'
```

### 源文件名
> 小写，如果需要的话使用下划线分隔单词。

### 主函数main
> 对于包含至少一个其他函数的足够长的脚本，需要称为 main 的函数。

了方便查找程序的开始，将主程序放入一个称为 main 的函数，作为最下面的函数。这使其和代码库的其余部分保持一致性，同时允许你定义更多变量为局部变量（如果主代码不是一个函数就不能这么做）。文件中最后的非注释行应该是对 main 函数的调用。

```bash
main "$@"
```

## 调用命令
> 总是检查返回值，并给出信息返回值。





## 尽量简短代码

里的简短不单单是指代码长度，而是只用到的命令数。原则上我们应当做到，能一条命令解决的问题绝不用两条命令解决。这不仅牵涉到代码的可读性，而且也关乎代码的执行效率。 

例如:
```sh
cat /etc/passwd | grep root   #不推荐
grep root /etc/passwd         #推荐
```

## 


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

