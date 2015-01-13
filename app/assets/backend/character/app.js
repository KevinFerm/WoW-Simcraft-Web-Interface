var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var counter = 1;
var fs = require('fs');
var sys = require('sys');
var libxmljs = require("libxmljs");
var exec = require('child_process').exec;
app.get('/', function(req, res){
  res.sendfile('index.html');
});
function addZero(i) {
  if (i < 10) {
    i = "0" + i;
  }
  return i;
}

function myFunction() {
  var d = new Date();
  var h = addZero(d.getHours());
  var m = addZero(d.getMinutes());
  var s = addZero(d.getSeconds());
  return h + ":" + m + ":" + s;
}
io.on('connection', function(socket){
  console.log('a user connected');
  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
  socket.on('join', function(data){
    console.log("Character joined: "+data.char_id)
    socket.join(data.char_id);
  });
  socket.on('sendserver', function(info){
    console.log('message: '+info.charstuff);
    var outputfilename = "../simc/"+info.char_id + info.character.name + "profile.json";
    var shellarg = "/vagrant/Huntersmark/app/assets/backend/simc/"+info.char_id + info.character.name + "profile.json";
    fs.writeFile(outputfilename, JSON.stringify(info.character,null,4), function(err){
      if(err){
        console.log(err);
      }else{
        console.log("saved");
      }
    });
    var stuff = info.charstuff.split(",");
    //var delfiles = exec('./delfiles.sh'+' armory='+info.charstuff);
    var xmlfile = {};
    var dps = {};
    var command = exec('../simc/runsim.sh' + ' local_json='+shellarg + ','+info.character.name+' '+info.character.name, function(error,stdout,stderr){
      var filep = __dirname+"/"+info.character.name+".xml";
      //console.dir(res);
      var xmlfile = getDPS(filep);
      var dps = xmlfile;
      console.log("Command: "+shellarg);
      console.dir("DPS: "+dps);
      io.sockets.in(info.char_id).emit('recievedps',dps);
      console.log('stdout: '+stdout);
      console.log('stderr: '+stderr);
      if(error !== null){
        console.log('exec error: ' +error);
      }
    });
    io.sockets.in(info.char_id).emit('sendserver',myFunction().toString() + ' : '+ info.char_id.toString() + ' - ' +counter.toString());
    counter = counter + 1;
  });

});

function getDPS(filePath) {
  var fs = require('fs');
  var xml2js = require('xml2js');
  var parser = new xml2js.Parser();
  var json;
  var res;
  var dps = {};
  var pdps;
  var outputfilename = 'myjsonn.json';
  try {
    var fileData = fs.readFileSync(filePath,'utf-8');
      pdps = parser.parseString(fileData, function (err,result){
        dps.dps = result['simulationcraft']['players'][0]['player'][0]['dps'][0]['$']['value'];
        dps.weights = result['simulationcraft']['players'][0]['player'][0]['scale_factors'][0]['metric'][1]['weights'][0]['stat'];
        console.log(dps);

        //res = JSON.stringify(result);
        fs.writeFile(outputfilename, JSON.stringify(result,null,4), function(err){
          if(err){
            console.log(err);
          }else{
            console.log("saved");
          }
        });
        return dps;
        //console.dir(res);
      });
      return dps;

  } catch (ex) {console.log(ex)}
 console.log("lol: "+fileData);
}

http.listen(1337, function(){
  console.log('listening on *:1337');
});