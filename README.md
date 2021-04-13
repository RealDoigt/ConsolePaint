# ConsolePaint
ConsolePaint is a work in progress Console UI library for .Net which doesn't use unmanaged and windows exclusive libraries. It can also handle images and display them in the console window.

# How to Install
## Visual Studio Code
First, you'll need the DLLs for Boo and ConsolePaint.

Next, import them to your workspace
```
.   My Project
├── .vscode
├── bin
├── obj
< Import these below >
├── Boo.Lang.dll
├── ConsolePaint.dll 
< Import these above >
├── program.cs
├── project.csproj
```

Go into your `.csproj` file, and add the following below.

```xml
  <ItemGroup>
    <Reference Include="./Boo.Lang.dll"></Reference>
    <Reference Include="./ConsolePaint.dll"></Reference>
  </ItemGroup>
```

If you put them into a folder, make sure to include them.
Like if you include them into a folder call `libs`; type like this instead.
```xml
<Reference Include="./libs/Boo.Lang.dll"></Reference>
```

Try the demo program to make sure it's working.

```csharp
using System;
using System.Drawing;
using ConsolePaint;

namespace MyProgram {
    class Program {
        public static void Main(string[] args){
            Painting.DrawCell(5, 2, ConsoleColor.Red);
        }
    }
}
