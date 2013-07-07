/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.service;
import flash.errors.Error;


class Alternative<Primary,Secondary>
{
	public var primaryAvailable(default, null) : Bool;
	public var primary(default, null): Primary;
	public var secondary(default, null): Secondary;

	public function new(primary : Primary,?secondary : Secondary) 
	{
		if (primary != null)
		{
			this.primary = primary;
			primaryAvailable = true;
		}
		else if (secondary != null)
		{
			this.secondary = secondary;
		}
		else
		{
			throw new Error("if primary not set secondary need to be set");
		}
	}
	
}