/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.amf;

import haxe.Json;
import wighawag.remote.RemoteCall;
import de.polygonal.core.codec.Base64;
import haxe.remoting.AMFConnection;
import haxe.crypto.Sha1;
import de.polygonal.ds.IntHashTable;
import msignal.Signal;

class AMFSignedRequestService implements RemoteCall
{
	private var connection: AMFConnection;
	private var secretKey:String;
	private var playerId:String;
	
	private var requestCounter : Int;
	
	private var signals : IntHashTable<Signal1<Dynamic>> ;
	
	public function new(url : String, playerId : String, secretKey : String) 
	{
		this.playerId = playerId;
		this.secretKey = secretKey;
		connection = AMFConnection.urlConnect(url);
		connection.setErrorHandler(onError);
		requestCounter = 0;
		signals = new IntHashTable<Signal1<Dynamic>>(16);
	}
	
	private function onError(error : Dynamic):Void 
	{
		trace(error);
	}
	
	public function signedRequestCall(params : Array<Dynamic>): Signal1<Dynamic>
	{
		requestCounter += 1;
		
		var parameters : Dynamic = { };
		parameters.playerId = playerId;
		parameters.methodName = params[0];
		if (params[1])
		{
			parameters.args = params[1];
		}
		
		
		var jsonData : String = Json.stringify(parameters);
		var data : String = Base64.encodeString(jsonData);
		
		
		var signature : String = Sha1.encode(secretKey + data + secretKey);
		
		
		var encoded_signature :String = Base64.encodeString(signature);
		
		var request : String = encoded_signature + "." + data;
		
		var signal : Signal1<Dynamic> = new Signal1();
		signals.set(requestCounter, signal);
		connection.signedRequestCall.call([requestCounter, request], onResult );
		return signal;
	}
	
	private function onResult(result : Dynamic):Void 
	{
		var signal : Signal1<Dynamic> = signals.get(result.id);
		signals.clr(result.id);
		signal.dispatch(result);
	}
	
}