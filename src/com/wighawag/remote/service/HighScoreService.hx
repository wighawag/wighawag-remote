package com.wighawag.remote.service;

interface HighScoreService 
{
	public function echo(message : String) : Response<String, ErrorMessage>;	
	public function getOwnHighScore() : Response<Score, ErrorMessage>; // the score do not contain proof neither a seed
	public function start(): Response<Seed, ErrorMessage>;
	public function setScore(score : Score): Response<String, ErrorMessage>; // String could be Bool
	public function getRandomScore(): Response<Alternative<Score,RetryMessage>, ErrorMessage>; 
	public function reviewScore(scoreReview : Score): Response<String, ErrorMessage>;	 // the scoreReview do not contain a proof, neither a seed // String could be Bool
	
	// admin
	public function forceReviewTimeUnit(value : Int) : Response<Int, ErrorMessage>;	
}