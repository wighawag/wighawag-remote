/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.authentification;

import haxe.Json;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables; 

import msignal.Signal;

class PasswordAuthentification 
{
	private var url:String;
	private var userId:String;
	private var password:String;
	
	private var onAuthenticated : Signal1<Dynamic>;

	public function new(url : String, userId : String, password : String)
	{
		this.url = url;
		this.userId = userId;
		this.password = password;
	}
	
	public function connect() : Signal1<Dynamic>
	{
		var request : URLRequest = new URLRequest(url);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("userId="+userId+"&password="+password+"&method=signedRequest");
		
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		urlLoader.addEventListener(Event.COMPLETE, onComplete);


        try{
            urlLoader.load(request);
        }
        catch(e : Dynamic){
            var timer : haxe.Timer = new haxe.Timer(10);
            timer.run = function(): Void{onError(null);timer.stop();};
        }
		
		onAuthenticated = new Signal1();
		return onAuthenticated;
	}
	
	private function onError(?event:Event):Void
	{
        if (event != null){
            trace(event.toString());
        }
		// TODO : for now :
		onAuthenticated.dispatch(null);
	}
	
	private function onComplete(e:Event):Void 
	{
		var data : Dynamic = Json.parse(e.target.data);
		trace("getting player : " + data);
		onAuthenticated.dispatch(data);
	}
	
}
