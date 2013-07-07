/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.service;

class Seed 
{

	public var seedList(default, null) : Array<Int>;
	public var version(default, null) : String;
	
	public function new(seedList : Array<Int>, version : String) 
	{
		this.seedList = seedList;
		this.version = version;
	}
	
}