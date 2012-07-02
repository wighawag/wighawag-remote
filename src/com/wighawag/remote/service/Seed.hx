package com.wighawag.remote.service;

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