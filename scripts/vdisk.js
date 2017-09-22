var WshShell = WScript.CreateObject("WScript.Shell");

// var x = WshShell.Run("calc");
// WScript.Echo("the return value is ",x);
// WScript.Echo("Hello World!");
// WshShell.Exec("diskpart");
// WshShell.Run("%comspec% /c <Console Command>");
// var p = { "a" : 123, "b" : 4};
// for (var key in p) {
//     if (p.hasOwnProperty(key)) {
//         WScript.Echo(key + " -> " + p[key]);
//     }
// }
// create vdisk file="C:\vdisks\disk1.vhd" maximum=16000 
// attach vdisk 
// create partition primary 
// assign letter=g 
// format

var commands = [
    ["create", "vdisk", { "file":"c:/test/test.vhd", "maximun":"1000", "type":"expandable"} ],
    ["attach", "vdisk"],
    ["create", "partition", "primary"],
    ["assign", {letter:"g"}],
    ["format"]
];

var command = ["create", "vdisk", { file:"c:/test/test.vhd", maximun:"1000", type:"expandable"} ];

function println(msg) {
    return WScript.Stdout.WriteLine(msg);
}
function print(msg) {
    return WScript.Stdout.Write(msg);
}

function obj2str(obj) {
    var output = "";
    // print("aaaaaaaaaaaaaa");
    for (var key in obj) {
        output += key + "=\"" + obj[key] + "\" ";
    }
    return output.slice(0,-1);
}

function cmd2str(cmd) {
    // print("typeof cmd=", typeof cmd );
    var output = "";
    for (var x in cmd) {
        if (typeof cmd[x] !== 'object') {
            output += cmd[x];
        } else {
            output += obj2str(cmd[x]);
        }
        output += " ";
    }
    return output.slice(0,-1);
}

function cmds2str(cmds) {
    var output = "";
    for (var x in cmds) {
        output += cmd2str(cmds[x]) + "\n";
    }
    return output;
}

print(cmds2str(commands));



function CheckServerStatus()
{
    // Ping the server
    // var ExecOperation = WshShell.Exec("ping www.google.com");
    var ExecOperation = WshShell.Exec("cat");
    print("hello");

    var StdIn  = ExecOperation.StdIn;
    // StdIn.Write("hello world");
    StdIn.Close();
    // // Check the operation's status
    // while (ExecOperation.Status == 0)
    //     WScript.Sleep(100);

    // // Get the operation's exit code
    // var ExCode = ExecOperation.ExitCode;

    // // Get the application's StdOut stream
    // var StdOut = ExecOperation.StdOut;

    // if (ExCode == 0)
    // print(StdOut.ReadAll());
}

// CheckServerStatus();
// var WshShell = new ActiveXObject("WScript.Shell");
// var oExec = WshShell.Exec("cat");

// while (oExec.Status == 0)
// {
//     print("hello");
//     WScript.Sleep(100);
// }

// print(oExec.Status);
// function Main()
// {
//     var WshShellExecObj = WshShell.Exec("cmd.exe");

//     // Flush the stream
//     var out = readTillChar(WshShellExecObj, ">");
//     Log.Message(out);

//     // Send the "ver" command and the new line character
//     WshShellExecObj.StdIn.Write("ver\n");
//     out = readTillChar(WshShellExecObj, ">");
//     Log.Message(out);
// }

// function readTillChar(WshShellExecObj, endChar)
// {
//     var out = "";
//     var curChar;
//     while (!WshShellExecObj.StdOut.AtEndOfStream)
//     {
//         curChar = WshShellExecObj.StdOut.Read(1);
//         out += curChar;
//         if (curChar == endChar) break;
//     }
//     return out;
// }
