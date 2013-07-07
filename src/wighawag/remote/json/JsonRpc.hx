/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.json;
import haxe.Json;
import wighawag.remote.RemoteCall;
import haxe.Http;
import de.polygonal.ds.IntHashTable;
import de.polygonal.core.codec.Base64;
import msignal.Signal;

class JsonRpc implements RemoteCall{

    private var secretKey:String;
    private var playerId:String;
    private var url:String;

    private var requestCounter : Int;

    private var signals : IntHashTable<Signal1<Dynamic>> ;

    public function new(url : String, playerId : String, secretKey : String)
    {
        this.url = url;
        this.playerId = playerId;
        this.secretKey = secretKey;
        requestCounter = 0;
        signals = new IntHashTable<Signal1<Dynamic>>(16);
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


        var signature : String = haxe.crypto.Sha1.encode(secretKey + data + secretKey);


        var encoded_signature :String = Base64.encodeString(signature);

        var request : String = encoded_signature + "." + data;

        var signal : Signal1<Dynamic> = new Signal1();
        signals.set(requestCounter, signal);

        var jsonRpcCall : String = '{"id" : ' + requestCounter + ', "method" : "signedRequestCall", "params": ["' + request + '"] }';

        var http : Http = new Http(url);
        http.setPostData(jsonRpcCall);

        http.onData = onResult;

        http.onError= function(msg : String) : Void {
            trace(msg);
        };

        http.request(true);

        return signal;
    }

    private function onResult(data : String):Void
    {
        var result : Dynamic = Json.parse(data);

        if (!Reflect.hasField(result, 'id') || result.id == 'unknown')
        {
             trace("Error " + result);
        }
        else
        {
            var signal : Signal1<Dynamic> = signals.get(result.id);
            signals.clr(result.id);
            signal.dispatch(result);
        }
    }
}
