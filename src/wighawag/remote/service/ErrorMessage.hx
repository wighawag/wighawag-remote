/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.service;

class ErrorMessage implements ServiceError
{
	public var text(default, null) : String;
	
	public function new(text : String) 
	{
		this.text = text;
	}
	
}