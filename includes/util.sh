#!/usr/bin/env bash

generateRandomName() {
	adverb="$(shuf -n 1 includes/adverbs.txt)"
	adjective="$(shuf -n 1 includes/adjectives.txt)"
	noun="$(shuf -n 1 includes/nouns.txt)"
	echo "$adverb$adjective$noun"
}
