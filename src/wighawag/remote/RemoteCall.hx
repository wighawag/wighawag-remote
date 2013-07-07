/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote;
import msignal.Signal;
interface RemoteCall {
    public function signedRequestCall(params : Array<Dynamic>): Signal1<Dynamic>;
}
