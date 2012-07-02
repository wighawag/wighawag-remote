package com.wighawag.remote.json;
import hsl.haxe.DirectSignaler;
import com.wighawag.remote.RemoteCall;
import haxe.Http;
import hsl.haxe.Signaler;
import de.polygonal.ds.IntHashTable;
import hxjson2.JSON;
import de.polygonal.core.io.Base64;
import haxe.SHA1;

class JsonRpc implements RemoteCall{

    private var secretKey:String;
    private var playerId:String;
    private var url:String;

    private var requestCounter : Int;

    private var signalers : IntHashTable<Signaler<Dynamic>> ;

    public function new(url : String, playerId : String, secretKey : String)
    {
        this.url = url;
        this.playerId = playerId;
        this.secretKey = secretKey;
        requestCounter = 0;
        signalers = new IntHashTable<Signaler<Dynamic>>(16);
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

        var jsonRpcCall : String = '{"id" : ' + requestCounter + ', "method" : "signedRequestCall", "params": ["' + request + '"] }';

        var http : Http = new Http(url);
        http.setPostData(jsonRpcCall);

        http.onData = onResult;

        http.onError= function(msg : String) : Void {
            trace(msg);
        };

        http.request(true);

        return signaler;
    }

    private function onResult(data : String):Void
    {
        var result : Dynamic = JSON.parse(data);

        if (!Reflect.hasField(result, 'id') || result.id == 'unknown')
        {
             trace("Error " + result);
        }
        else
        {
            var signaler : Signaler<Dynamic> = signalers.get(result.id);
            signalers.clr(result.id);
            signaler.dispatch(result);
        }
    }
}
