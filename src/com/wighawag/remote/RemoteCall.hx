package com.wighawag.remote;
import hsl.haxe.Signaler;
interface RemoteCall {
    public function signedRequestCall(params : Array<Dynamic>): Signaler<Dynamic>;
}
