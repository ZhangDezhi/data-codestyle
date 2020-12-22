#Qt 编码规范 


> 参考: https://wiki.qt.io/Qt_Coding_Style


## 缩进
     采用4个空格
     空格，不要用TAB！


## 变量声明
    每行一个变量
    尽可能避免短的变量名(比如"a", "rbarr", "nughdeget")
    单字符的变量只在临时变量或循环的计数中使用
    等到真正需要使用时再定义变量

```cpp
 // Wrong
 int a, b;
 char *c, *d;

 // Correct
 int height;
 int width;
 char *nameOfThis;
 char *nameOfThat;
```
    以小写字符开头，后续单词以大写开头
    避免使用缩写

```cpp
 // Wrong
 short Cntr;
 char ITEM_DELIM = ' ';

 // Correct
 short counter;
 char itemDelimiter = ' ';
```
    类名总是以大写开头。公有类以Q开头(QRgb)，公有函数通常以q开头(qRgb)。
    首字母缩写是驼峰大小写的(例如QXmlStreamReader，而不是QXmlStreamReader)。

## 空白 

    利用空行将语句恰当地分组
    总是使用一个空行(不要空多行)
    总是在每个关键字和大括号前使用一个空格
```cpp
 // Wrong
 if(foo){
 }

 // Correct
 if (foo) {
 }
```
    对指针和引用，在类型和*、&之间加一个空格，但在*、&与变量之间不加空格

```cpp
 char *x;
 const QString &myString;
 const char * const y = "hello";
```
    二元操作符前后加空白
    每个逗号后面要留一个空格
    类型转换后不加空白
    尽量避免C风格的类型转换

```cpp
  // Wrong
 char* blockOfMemory = (char* ) malloc(data.size());

 // Correct
 char *blockOfMemory = reinterpret_cast<char *>(malloc(data.size());
 ```

    不要把多个语句放在一行
    通过扩展，为控制流语句的主体使用新行
```cpp
 // Wrong
 if (foo) bar();

 // Correct
 if (foo)
     bar();
```

## 大括号

    基本原则：左大括号和语句保持在同一行：
```cpp
 // Wrong
 if (codec)
 {
 }
 else
 {
 }

 // Correct
 if (codec) {
 } else {
 }
```
    (例外)函数定义和类定义中，左大括号总是单独占一行

```cpp
 static void foo(int g)
 {
     qDebug("foo: %i", g);
 }

 class Moo
 {
 };
```
    控制语句的body中只有一行时不使用大括号
```cpp
// Wrong
 if (address.isEmpty()) {
     return false;
 }

 for (int i = 0; i < 10; ++i) {
     qDebug("%i", i);
 }

 // Correct
 if (address.isEmpty())
     return false;

 for (int i = 0; i < 10; ++i)
     qDebug("%i", i);
```
    例外1：如果父语句跨多行，则使用大括号

```cpp
 // Correct
 if (address.isEmpty() || !isValid()
     || !codec) {
     return false;
 }
```
    例外2：在if-else结构中，有一处跨多行，则使用大括号

```cpp
 // Wrong
 if (address.isEmpty())
     qDebug("empty!");
 else {
     qDebug("%s", qPrintable(address));
     it;
 }

 // Correct
 if (address.isEmpty()) {
     qDebug("empty!");
 } else {
     qDebug("%s", qPrintable(address));
     it;
 }

 // Wrong
 if (a)
     …
 else
     if (b)
         …

 // Correct
 if (a) {
     …
 } else {
     if (b)
         …
 }
```
    如果控制语句的body为空，则使用大括号
    
```cpp
 // Wrong
 while (a);

 // Correct
 while (a) {}
```

## 圆括号

    使用圆括号将表达式分组
```cpp
 // Wrong
 if (a && b || c)

 // Correct
 if ((a && b) || c)

 // Wrong
 a + b & c

 // Correct
 (a + b) & c
```

## Switch 语句

    case 和 switch 位于同一列
    每一个case必须有一个break(或renturn)语句，或者用注释说明无需break

```cpp
 switch (myEnum) {
 case Value1:
   doSomething();
   break;
 case Value2:
 case Value3:
   doSomethingElse();
   Q_FALLTHROUGH();
 default:
   defaultHandling();
   break;
 }
```


## 跳转语句(中断、继续、返回和转到)
    
    不要在跳转语句后面放'else'
```cpp
 // Wrong
 if (thisOrThat)
     return;
 else
     somethingElse();

 // Correct
 if (thisOrThat)
     return;
 somethingElse();
```
    例外:如果代码本身是对称的，使用'else'是允许的，以可视化的对称

## 断行

    保持每行短于100 个字符，需要时进行断行

    注释/api文档 文本的应保持80列以下。 根据实际情况避免出现交错段落.
    逗号放一行的结束，操作符放到一行的开头。如果你的编辑器太窄，一个放在行尾的操作符不容易被看到。

```cpp
 // Wrong
 if (longExpression +
     otherLongExpression +
     otherOtherLongExpression) {
 }

 // Correct
 if (longExpression
     + otherLongExpression
     + otherOtherLongExpression) {
 }
```

## 继承与关键字 `virtual`
    重新实现一个虚函数时，头文件中 不 放置 virtual 关键字。

## 通用例外
    如果它使你的代码看起来不好，你可以打破任何一个规则 。

```cpp
Category:
    Developing Qt::Guidelines
```

## 格式化参数库:

    下面的代码片段可以被艺术风格用于重新格式化您的代码。![][http://astyle.sourceforge.net/]

```shell
--style=kr 
--indent=spaces=4 
--align-pointer=name 
--align-reference=name 
--convert-tabs 
--attach-namespaces
--max-code-length=100 
--max-instatement-indent=120 
--pad-header
--pad-oper
```

## 自动格式化


你可以使用clang-format和git-clang-format来重新格式化你的代码。qt5。git仓库提供了一个clang格式文件，用于为Qt代码编码规则。将此复制到根目录，让clang-format选 

https://clang.llvm.org/docs/ClangFormat.html
https://github.com/llvm/llvm-project/blob/master/clang/tools/clang-format/git-clang-format

