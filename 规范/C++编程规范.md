参考:
1. https://wiki.qt.io/Coding_Conventions
2. https://zh-google-styleguide.readthedocs.io/en/latest/google-cpp-styleguide/contents/
3. 


## c++的特性

    不要使用异常
    不要使用rtti（运行时类型信息；即typeinfo结构，dynamic_cast或typeid运算符，包括引发异常）
    明智地使用模板，不仅仅是因为可以。

## 在Qt源代码的公约
    所有的源代码是UTF-8
    每个QObject子类都必须具有Q_OBJECT宏，即使它没有信号或插槽也是如此，否则qobject_cast将失败。
    在connect语句中标准化信号+插槽的参数（请参阅QMetaObject :: normalizedSignature），以获得更快的信号/插槽查找。 您可以使用qtrepotools / util / normalize标准化现有代码。

### 头文件
    在公共头文件中，请始终使用以下形式包括Qt头：#include <QtCore / qwhatever.h>。 库前缀对于Mac OS X框架是必需的，对于非qmake项目非常方便。
    在源文件中，首先包括专用标头，然后是通用标头。 用空行分隔类别。

```cpp
#include <qstring.h> // Qt class
#include <new> // STL stuff
#include <limits.h> // system stuff
```
    如果需要包括qplatformdefs.h，请始终将其作为第一个头文件
    如果需要包括专用头，请小心。 不管what_p.h位于哪个模块或目录中，请使用以下语法。

```cpp
#include <private/whatever_p.h>
```

