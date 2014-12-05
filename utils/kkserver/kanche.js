/**
 * Created by mac on 13-10-29.
 */
var server,
    ip = "0.0.0.0",
    port = 8899,
    http = require('http'),
    fs = require('fs'),
    folderPath = __dirname + "/static",
    url = require('url'),
    encode = "utf8";


server = http.createServer(function(req, res){
    var parts = url.parse(req.url, true);

    // Extract query.
    var query = parts.query;
    // Extract path name.
    var pathname = parts.pathname;
    // remove /btnnow
    // pathname = pathname.replace('/btcnow','');
    var filePath = '';
    // var filePath = folderPath + pathname + '.json';

    console.log(parts);
    console.log("=================");

    if(parts.pathname == '/vehicle')
    {
        if (query.vehicleType == "all") {
            
            filePath = folderPath + "/vehicle.json";
            console.log(filePath);
            console.log("=================");

            fs.readFile(filePath, encode, function(err, file) {
                if(err){
                    res.writeHead(404, {'Content-Type': 'text/plain'});
                    res.end();
                    return;
                }
                res.writeHead(200, {'Content-Type':'application/json'});
                res.write(file);
                res.end();
            });
        };

    }

    if(parts.pathname == '/category')
    {            
            filePath = folderPath + "/category.json";
            console.log(filePath);
            console.log("=================");

            fs.readFile(filePath, encode, function(err, file) {
                if(err){
                    res.writeHead(404, {'Content-Type': 'text/plain'});
                    res.end();
                    return;
                }
                res.writeHead(200, {'Content-Type':'application/json'});
                res.write(file);
                res.end();
            });
    }

    if(parts.pathname == '/share/job/search')
    {            
            filePath = folderPath + "/history.json";
            console.log(filePath);
            console.log("=================");

            fs.readFile(filePath, encode, function(err, file) {
                if(err){
                    res.writeHead(404, {'Content-Type': 'text/plain'});
                    res.end();
                    return;
                }
                res.writeHead(200, {'Content-Type':'application/json'});
                res.write(file);
                res.end();
            });
    }

    if(parts.pathname == '/share/job/restart')
    {            
            console.log("=========/share/job/restart ========");

            res.writeHead(200, {'Content-Type':'application/json'});
            var result = {"result":"OK"};
            console.log(JSON.stringify(result));
            res.write(JSON.stringify(result));
            res.end();
    }

    if(parts.pathname == '/share/job/history/list')
    {            
            filePath = folderPath + "/historyLog.json";
            console.log(filePath);
            console.log("=================");

            fs.readFile(filePath, encode, function(err, file) {
                if(err){
                    res.writeHead(404, {'Content-Type': 'text/plain'});
                    res.end();
                    return;
                }
                res.writeHead(200, {'Content-Type':'application/json'});
                res.write(file);
                res.end();
            });
    }


    if(parts.pathname == '/app')
    {
        filePath = folderPath + "/merchantOld.html";
        // console.log(filePath);
        fs.readFile(filePath, encode, function(err, file) {
            if(err){
                res.writeHead(404, {'Content-Type': 'text/plain'});
                res.end();
                return;
            }
            res.writeHead(200, {'Content-Type':'text/html'});
            res.write(file);
            res.end();
        });
    }




});

server.listen(port, ip);
console.log("Server running at http://"+ ip + ":"+port);