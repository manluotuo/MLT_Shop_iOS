require('shelljs/global');
var plist = require('plist');

//
var OSS = require('aliyun-oss');
var option = {
  accessKeyId : "KWIlr6mqBb9r2Yel",
  accessKeySecret : "2xZh7uSnwP5DI30fyIZDtNqWlakO3e",
  host:'oss-cn-beijing.aliyuncs.com'
};

var oss = OSS.createClient(option);

//
var fs = require('fs');
var path = require('path');
var version = '';
var type = '';
var build = '';
var bucket =  '';
var exportPath = '';
var PROJECT_PATH = fs.realpathSync('.')+"/";
console.log(PROJECT_PATH);

var workspacePath = PROJECT_PATH + "mltshop.xcworkspace";
var plistPath = PROJECT_PATH + "mltshop/Info.plist"
var xcconfigPath = PROJECT_PATH + "mltshop/XCConfig/";
// first read version and build then xcode build
// after build xcode will auto + 1 build
// now use the `parse()` and `build()` functions

fs.readFile(plistPath, {encoding: 'utf-8'}, function(err,data){
  if (!err){
  	var val = plist.parse(data);
  	console.log("=============================")
		console.log("Version: "+val.CFBundleShortVersionString);  // 1.0.1
		console.log("Build: "+val.CFBundleVersion);  // 1080
  	console.log("=========Start Build=========")
  	console.log("=============================")

		process_args_build(val.CFBundleShortVersionString,val.CFBundleVersion);
  }else{
      console.log(err);
  }
});



function process_args_build(theVersion,theBuild){
	// process 处理参数
	process.stdin.resume();
	process.stdin.setEncoding('utf8');

	process.argv.forEach(function(val, index, array) {
	  console.log(index + ': ' + val);
	});

	var args = process.argv;

	version = theVersion;
	type = args[2];
	build = theBuild;
	bucket =  '';

	if (type == "dev") {
		bucket = 'manluotuo-ios';
		version = type + '_' + version ;
	}else if(type == "release"){
		bucket = 'manluotuo-ios';
		version = type + '_' + version ;
	}else if(type == "qa"){
		bucket = 'manluotuo-ios';
		version = type + '_' + version ;
	}else if(type == "stage"){
		bucket = 'manluotuo-ios';
		version = type + '_' + version ;
	}else{
		bucket = '';
	}

	xcconfigPath = xcconfigPath + type+".xcconfig";
	console.log(xcconfigPath);

	var archivePath = PROJECT_PATH + "ipa/xcodebuild/mltshop_"+version+"_"+build+".xcarchive";
	exportPath =  PROJECT_PATH + "ipa/xcodebuild/mltshop_"+version+"_"+build+".ipa";

	var command_1 = 'xcodebuild -workspace '+ workspacePath +' -scheme "mltshop" '+ ' -xcconfig ' + xcconfigPath 
	+' -sdk "iphoneos" archive -archivePath '+ archivePath;

	var command_2 = 'xcodebuild -exportArchive -exportFormat ipa  -archivePath '+ 
	archivePath +' -exportPath '+exportPath+' -exportProvisioningProfile "AdHocMLTShop"';



	console.log(version);
	console.log(build);
	console.log(bucket);
	console.log(command_1);
	console.log(command_2);


	if (version != "" &&  build != "" && bucket != "") {
		console.log('xcodebuild');
		xcodebuild(command_1, command_2);

	}else{
		console.log("args not empty");
	}

}



function upload_ipa(){

	var objectName = "mltshop.ipa";
	if(type == "release" || type == "stage"){
		objectName = "mltshop_"+version+".ipa";
	}

	oss.putObject({
	  bucket: bucket,
	  object: objectName,
	  source: exportPath,
	  headers: {
	  }
	}, function (err, res) {
		if (err == null) {
			console.log(res);
			upload_archive();
		}else{
			console.log(err);
		}

	});
}

function upload_archive(){
	oss.putObject({
	  bucket: bucket,
	  object: "archives/ios/mltshop_"+version+"_"+build+".ipa",
	  source: exportPath,
	  headers: {
	  }
	}, function (err, res) {
		if (err == null) {
			console.log(res);

			// exit
			process.exit(0)

		}else{
			console.log(err);
		}		
	});
}


function xcodebuild(command_1,command_2){
	if (exec(command_1).code == 0) {
		
		echo('command_1 success');

		if (exec(command_2).code == 0) {
			echo('command_2 success');

			upload_ipa();

		}else{
			echo('command_2 failed');
		}
	}else{
		echo('command_1 failed');
	}
}

