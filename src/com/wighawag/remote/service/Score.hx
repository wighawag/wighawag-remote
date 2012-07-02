package com.wighawag.remote.service;


class Score 
{
	public var value(default, null) : Int;
	public var time(default, null) : Int;
	public var proof(default, null) : String;
	public var seed(default, null) : Array<Int>;
	public var version(default, null) : String;
	
	public function new(value : Int, time : Int, proof : String, seed : Array<Int>, version : String) 
	{
		this.value = value;
		this.time = time;
		this.proof = proof;
		this.seed = seed;
		this.version = version;
	}
	
}