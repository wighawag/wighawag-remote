package com.wighawag.remote.amf;

import com.wighawag.remote.RemoteCall;
import de.polygonal.core.io.Base64;
import nme.Lib;
import haxe.remoting.AMFConnection;
import haxe.SHA1;
import de.polygonal.ds.IntHashTable;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import hxjson2.JSON;

class AMFSignedRequestService implements RemoteCall
{
	private var connection: AMFConnection;
	private var secretKey:String;
	private var playerId:String;
	
	private var requestCounter : Int;
	
	private var signalers : IntHashTable<Signaler<Dynamic>> ;
	
	public function new(url : String, playerId : String, secretKey : String) 
	{
		this.playerId = playerId;
		this.secretKey = secretKey;
		connection = AMFConnection.urlConnect(url);
		connection.setErrorHandler(onError);
		requestCounter = 0;
		signalers = new IntHashTable<Signaler<Dynamic>>(16);
	}
	
	private function onError(error : Dynamic):Void 
	{
		trace(error);
	}
	
	public function signedRequestCall(params : Array<Dynamic>): Signaler<Dynamic>
	{
		requestCounter += 1;
		
		var parameters : Dynamic = { };
		parameters.playerId = playerId;
		parameters.methodName = params[0];
		if (params[1])
		{
			parameters.args = params[1];
		}
		
		
		var jsonData : String = JSON.stringify(parameters);
		var data : String = Base64.encodeString(jsonData);
		
		
		var signature : String = SHA1.encode(secretKey + data + secretKey);
		
		
		var encoded_signature :String = Base64.encodeString(signature);
		
		var request : String = encoded_signature + "." + data;
		
		var signaler : Signaler<Dynamic> = new DirectSignaler<Dynamic>(this);
		signalers.set(requestCounter, signaler);
		connection.signedRequestCall.call([requestCounter, request], onResult );
		return signaler;
	}
	
	private function onResult(result : Dynamic):Void 
	{
		var signaler : Signaler<Dynamic> = signalers.get(result.id);
		signalers.clr(result.id);
		signaler.dispatch(result);
	}
	
}