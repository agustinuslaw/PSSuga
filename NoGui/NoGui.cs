/*
NOTE: Must be run in Windows PowerShell (5.1), PowerShell (7+) cannot create standalone exes.

This is designed to create a simple exe that can be used to spawn any console
application with a hidden Window. As NoGui.exe is a GUI executable it won't
spawn with an associated console window and can be used to then create a new
process with a hidden console window with the arguments it was created with.
The arguments after -- will be used as the new process, for example

    C:\path\NoGui.exe -- pwsh.exe
    
Will create a new `pwsh.exe` process by looking it up in the PATH env vars.

    C:\path\NoGui.exe -- "C:\Program Files\PowerShell\7\pwsh.exe" -Command "'abc' > C:\Windows\TEMP\test.txt"
    
Will create a new `pwsh.exe` at the absolute path specified and runs a command.

Gist by jborean93 https://gist.githubusercontent.com/jborean93/d8e84c4ab744d0237a1ff650acec1086
*/

using System;
using System.Runtime.InteropServices;
using System.Text;

namespace Suga
{
    class NoGui
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct PROCESS_INFORMATION
        {
            public IntPtr hProcess;
            public IntPtr hThread;
            public int dwProcessId;
            public int dwThreadId;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct STARTUPINFOW
        {
            public Int32 cb;
            public IntPtr lpReserved;
            public IntPtr lpDesktop;
            public IntPtr lpTitle;
            public Int32 dwX;
            public Int32 dwY;
            public Int32 dwXSize;
            public Int32 dwYSize;
            public Int32 dwXCountChars;
            public Int32 dwYCountChars;
            public Int32 dwFillAttribute;
            public Int32 dwFlags;
            public Int16 wShowWindow;
            public Int16 cbReserved2;
            public IntPtr lpReserved2;
            public IntPtr hStdInput;
            public IntPtr hStdOutput;
            public IntPtr hStdError;
        }

        [DllImport("Kernel32.dll", SetLastError = true)]
        public static extern bool CloseHandle(
            IntPtr hObject);

        [DllImport("Kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern bool CreateProcessW(
            [MarshalAs(UnmanagedType.LPWStr)] string lpApplicationName,
            StringBuilder lpCommandLine,
            IntPtr lpProcessAttributes,
            IntPtr lpThreadAttributes,
            bool bInheritHandles,
            int dwCreationFlags,
            IntPtr lpEnvironment,
            [MarshalAs(UnmanagedType.LPWStr)] string lpCurrentDirectory,
            ref STARTUPINFOW lpStartupInfo,
            out PROCESS_INFORMATION lpProcessInformation);

        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetCommandLineW();

        static void Main()
        {
            IntPtr cmdLinePtr = GetCommandLineW();
            string cmdLine = Marshal.PtrToStringUni(cmdLinePtr);
            int cmdLineArgsIdx = cmdLine.IndexOf(" -- ");
            StringBuilder newCmdLine = new StringBuilder(cmdLine.Substring(cmdLineArgsIdx + 4));

            STARTUPINFOW si = new STARTUPINFOW()
            {
                cb = Marshal.SizeOf<STARTUPINFOW>(),
                dwFlags = 0x00000001, // STARTF_USESHOWWINDOW
                wShowWindow = 0, // SW_HIDE
            };
            PROCESS_INFORMATION pi;
            bool res = CreateProcessW(
                null,
                newCmdLine,
                IntPtr.Zero,
                IntPtr.Zero,
                true,
                0x00000410,  // CREATE_NEW_CONSOLE | CREATE_UNICODE_ENVIRONMENT
                IntPtr.Zero,
                null,
                ref si,
                out pi
            );

            if (res)
            {
                CloseHandle(pi.hProcess);
                CloseHandle(pi.hThread);
            }
        }
    }
}