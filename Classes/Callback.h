//
//  Callback.h
//  BomberBilly
//
//  Created by Ruud van Falier van Falier on 3/21/11.
//  Copyright 2011 DotTech. All rights reserved.
//


// Struct that allows us to define callback methods
typedef struct sCallback {
	id callbackObject;
	SEL callbackMethod;
} Callback;


// Use this function to create a ProgressCallback object
static Callback CallbackCreate(id obj, SEL method) 
{
    Callback r;
	r.callbackObject = obj;
	r.callbackMethod = method;
	return r;
}