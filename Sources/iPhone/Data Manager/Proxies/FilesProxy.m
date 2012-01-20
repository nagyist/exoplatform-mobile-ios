//
//  FilesProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesProxy.h"
#import "NSString+HTML.h"
#import "eXo_Constants.h"
#import "DataProcess.h"
#import "Reachability.h"
#import "AuthenticateProxy.h"
#import "TouchXML.h"
#import "defines.h"

@implementation FilesProxy

@synthesize _isWorkingWithMultipeUserLevel, _strUserRepository;

#pragma mark -
#pragma mark Utils method for files

+ (NSString*)stringEncodedWithBase64:(NSString*)str
{
	static const char *tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	const char *s = [str UTF8String];
	int length = [str length];
	char *tmp = malloc(length * 4 / 3 + 4);
	
	int i = 0;
	int n = 0;
	char *p = tmp;
	
	while (i < length)
	{
		n = s[i++];
		n *= 256;
		if (i < length) n += s[i];
		i++;
		n *= 256;
		if (i < length) n += s[i];
		i++;
		
		p[0] = tbl[((n & 0x00fc0000) >> 18)];
		p[1] = tbl[((n & 0x0003f000) >> 12)];
		p[2] = tbl[((n & 0x00000fc0) >>  6)];
		p[3] = tbl[((n & 0x0000003f) >>  0)];
		
		if (i > length) p[3] = '=';
		if (i > length + 1) p[2] = '=';
		
		p += 4;
	}
	
	*p = '\0';
	
	NSString* ret = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
	free(tmp);
	
	return ret;
}

+ (NSString *)urlForFileAction:(NSString *)url
{
	url = [DataProcess encodeUrl:url];
	
	NSRange range;
	range = [url rangeOfString:@"http://"];
	if(range.length == 0)
		url = [url stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	return url;
	
}


#pragma mark -
#pragma NSObject Methods

+ (FilesProxy *)sharedInstance
{
	static FilesProxy *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[FilesProxy alloc] init];
		}
		return sharedInstance;
	}
    
	return sharedInstance;
}

- (id)init{
    if ((self = [super init])) { 
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (NSString *)fullURLofFile:(NSString *)path {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    return [NSString stringWithFormat:@"%@%@%@", domain, DOCUMENT_JCR_PATH_REST, path];
}

#pragma mark -
#pragma mark Files retrieving methods

- (NSArray*)getDrives:(NSString*)driveName {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];

    // Initialize the array of files
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];	
	
    // Create URL for getting data
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", domain, DOCUMENT_DRIVE_PATH_REST, driveName]];
	
    // Create a new parser object based on the TouchXML "CXMLDocument" class
    CXMLDocument *parser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    // Create a new Array object to be used with the looping of the results from the parser
    NSArray *resultNodes = NULL;
	
    // Set the resultNodes Array to contain an object for every instance of an  node file/folder data
    resultNodes = [parser nodesForXPath:@"//Folder" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = file.name;
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        if(file.currentFolder == nil)
            file.currentFolder = @"";
        file.isFolder = YES;
		
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }

    return folderArray;
}

- (NSArray*)getContentOfFolder:(File *)file {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    
    // Initialize the array of files
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];
	
    // Create URL for getting data
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", domain, DOCUMENT_FILE_PATH_REST, file.driveName, DOCUMENT_WORKSPACE_NAME, file.workspaceName, DOCUMENT_CURRENT_FOLDER, file.currentFolder];
    NSURL *url = [NSURL URLWithString: [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    // Create a new parser object based on the TouchXML "CXMLDocument" class
    CXMLDocument *parser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    // Create a new Array object to be used with the looping of the results from the parser
    NSArray *resultNodes = NULL;
	
    // Set the resultNodes Array to contain an object for every instance of an  node file/folder data
    resultNodes = [parser nodesForXPath:@"//Folder/Folders/Folder" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = [[resultElement attributeForName:@"driveName"] stringValue];
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        file.isFolder = YES;
		file.path = [self fullURLofFile:[[resultElement attributeForName:@"path"] stringValue]];
        
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }
    
    resultNodes = [parser nodesForXPath:@"//Folder/Files/File" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = [[resultElement attributeForName:@"driveName"] stringValue];
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        file.isFolder = NO;
        file.path = [self fullURLofFile:[[resultElement attributeForName:@"path"] stringValue]];
        file.nodeType = [[resultElement attributeForName:@"nodeType"] stringValue];
		
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }
    
    return folderArray; 
    
}

- (void)creatUserRepositoryHomeUrl
{
   
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    
    NSString *urlForUserRepo = [NSString stringWithFormat:@"%@%@/Users", domain, DOCUMENT_JCR_PATH_REST];
    
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:urlForUserRepo];
    
    int length = [username length];
    
    int numberOfUserLevel = 2;
    if(length >= 4)
        numberOfUserLevel = 3;
    
    for(int i = 1; i <= numberOfUserLevel; i++)
    {
        NSMutableString *userNameLevel = [[NSMutableString alloc] initWithString:[username substringToIndex:i]];
        
        for(int j = 1; j <= 3; j++)
        {
            [userNameLevel appendString:@"_"];
        }
        
        [urlStr appendFormat:@"/%@", userNameLevel];
        
        [userNameLevel release];
    }
    
    [urlStr appendFormat:@"/%@", username];
    
    self._isWorkingWithMultipeUserLevel = [[AuthenticateProxy sharedInstance] isReachabilityURL:urlStr userName:username password:password];
    
    if(_isWorkingWithMultipeUserLevel)    
        self._strUserRepository = [NSString stringWithString:urlStr];
    else
        self._strUserRepository = [NSString stringWithFormat:@"%@/%@", urlForUserRepo, username];
    
}

- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [self fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
}

-(NSString *)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data
{	
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];

    
	source = [DataProcess encodeUrl:source];
	destination = [DataProcess encodeUrl:destination];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSHTTPURLResponse* response;
	NSError* error;
    
    //Message for error
    NSString *errorMessage;
    
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[NSURL URLWithString:source]]; 
	
	if([protocol isEqualToString:kFileProtocolForDelete])
	{
		[request setHTTPMethod:@"DELETE"];
		
	}else if([protocol isEqualToString:kFileProtocolForUpload])
	{
		[request setHTTPMethod:@"PUT"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		[request setHTTPBody:data];
		
	}
    if([protocol isEqualToString:@"MKCOL"])
	{
		[request setHTTPMethod:@"MKCOL"];
	}
	else if([protocol isEqualToString:kFileProtocolForCopy])
	{
		[request setHTTPMethod:@"COPY"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
        
	}else if ([protocol isEqualToString:kFileProtocolForMove])
	{
		[request setHTTPMethod:kFileProtocolForMove];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		
		if([source isEqualToString:destination]) {
			
            //Put the label into the error
            // TODO Localize this label
            errorMessage = [NSString stringWithFormat:@"Can not move file to its location"];
             
            [request release];
            
			return errorMessage;
		}
	}
	
	NSString *s = @"Basic ";
    NSString *author = [s stringByAppendingString: [FilesProxy stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
    [request release];
    
	NSUInteger statusCode = [response statusCode];
	if(!(statusCode >= 200 && statusCode < 300))
	{
        //Put the label into the error
        // TODO Localize this label
        errorMessage = [NSString stringWithFormat:@"Can not transfer file"];
        
        return errorMessage;
		        
    }
    
    [pool release];
    
    
	return nil;
}

-(BOOL)createNewFolderWithURL:(NSString *)strUrl folderName:(NSString *)name
{
    BOOL returnValue = NO;
    
    NSURL *url = nil;
    
    if(strUrl)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", strUrl, name]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _strUserRepository, name]];
    
    BOOL isExistedUrl = [self isExistedUrl:[NSString stringWithFormat:@"%@/%@", strUrl, name]];
    
    if(isExistedUrl)
    {
        returnValue = YES; 
    }
    else
    {
        NSHTTPURLResponse* response;
        NSError* error;
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
        [request setURL:url];
        
        [request setHTTPMethod:@"MKCOL"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
        NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
        
        NSString *s = @"Basic ";
        NSString *author = [s stringByAppendingString: [FilesProxy stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
        [request setValue:author forHTTPHeaderField:@"Authorization"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
        [request release];
        
        NSUInteger statusCode = [response statusCode];
        if(statusCode >= 200 && statusCode < 300)
        {
            // TODO Localize this label
            returnValue = YES;
            
        }  
        
    }
    
	return returnValue;
}

-(BOOL)isExistedUrl:(NSString *)strUrl
{
    
    BOOL returnValue = NO;
    
    returnValue = [[AuthenticateProxy sharedInstance] isReachabilityURL:strUrl userName:nil password:nil];
    
    return returnValue;
    
}

@end
