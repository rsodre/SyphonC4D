/////////////////////////////////////////////////////////////
// CINEMA 4D SDK                                           //
/////////////////////////////////////////////////////////////
// (c) 1989-2011 MAXON Computer GmbH, all rights reserved  //
/////////////////////////////////////////////////////////////

// This is the main file of the CINEMA 4D SDK
//
// When you create your own projects much less code is needed (this file is rather long as it tries to show all kinds of different uses).
//
// An empty project simply looks like this:
//
// #include "c4d.h"
//
// Bool PluginStart(void)
// {
//   ...do or register something...
//   return true;
// }
//
// void PluginEnd(void)
// {
// }
//
// Bool PluginMessage(Int32 id, void *data)
// {
//   return false;
// }
//


#include "c4d.h"
#include "r13.h"
#include <string.h>
#include "main.h"

// forward declarations
Bool RegisterSyphonPlugin(void);

// R13
/*
C4D_CrashHandler old_handler;
void SDKCrashHandler(char *crashinfo)
{
	//printf("SDK CrashInfo:\n");
	//printf(crashinfo);

	// don't forget to call the original handler!!!
	//if (old_handler) (*old_handler)(crashinfo);
}
void EnhanceMainMenu(void)
{
	// do this only if necessary - otherwise the user will end up with dozens of menus!
	BaseContainer *bc = GetMenuResource(String("M_EDITOR"));
	if (!bc) return;

	// search for the most important menu entry. if present, the user has customized the settings
	// -> don't add menu again
	if (SearchMenuResource(bc,String("PLUGIN_CMD_1000472")))
		return;

	GeData *last = SearchPluginMenuResource();

	BaseContainer sc;
	sc.InsData(MENURESOURCE_SUBTITLE,String("SDK Test"));
	sc.InsData(MENURESOURCE_COMMAND,String("IDM_NEU")); // add C4D's new scene command to menu
	sc.InsData(MENURESOURCE_SEPERATOR,TRUE);
	sc.InsData(MENURESOURCE_COMMAND,String("PLUGIN_CMD_1000472")); // add ActiveObject dialog to menu

	if (last)
		bc->InsDataAfter(MENURESOURCE_STRING,sc,last);
	else // user killed plugin menu - add as last overall entry
		bc->InsData(MENURESOURCE_STRING,sc);
}
*/

Bool PluginStart(void)
{
	// R13
	// example of installing a crashhandler
	// remove this if you don't need it!
	//{
	//	old_handler = C4DOS.CrashHandler; // backup the original handler (must be called!)
	//	C4DOS.CrashHandler = SDKCrashHandler; // insert the own handler
	//}

	if (!RegisterSyphonPlugin())
		return false;

	return true;
}

void PluginEnd(void)
{
}

Bool PluginMessage(Int32 id, void* data)
{
	switch (id)
	{
		case C4DPL_INIT_SYS:
			if (!resource.Init())
				return false;		// don't start plugin without resource

			// register example datatype. This is happening at the earliest possible time
			//if (!RegisterExampleDataType())
			//	return false;

			// serial hook example; if used must be registered before PluginStart(), best in C4DPL_INIT_SYS
			//if (!RegisterExampleSNHook())
			//	return false;

			return true;

		case C4DMSG_PRIORITY:
			//react to this message to set a plugin priority (to determine in which order plugins are initialized or loaded
			//SetPluginPriority(data, mypriority);
			// ROGER
			SetPluginPriority(data, C4DPL_INIT_PRIORITY_PLUGINS-1000000);
			return true;

		case C4DPL_BUILDMENU:
			//react to this message to dynamically enhance the menu
			//EnhanceMainMenu();
			break;

		case C4DPL_COMMANDLINEARGS:
			//react to this message to react to command line arguments on startup
			/*{
				C4DPL_CommandLineArgs *args = (C4DPL_CommandLineArgs*)data;
				Int32 i;

				for (i = 0; i<args->argc; i++)
				{
					if (!args->argv[i]) continue;

					if (!strcmp(args->argv[i],"--help") || !strcmp(args->argv[i],"-help"))
					{
						// do not clear the entry so that other plugins can make their output!!!
						GePrint("\x01-SDK is here :-)");
					}
					else if (!strcmp(args->argv[i],"-SDK"))
					{
						args->argv[i] = nullptr;
						GePrint("\x01-SDK executed:-)");
					}
					else if (!strcmp(args->argv[i],"-plugincrash"))
					{
						args->argv[i] = nullptr;
						*((Int32*)0) = 1234;
					}
				}
			}*/
			break;

		case C4DPL_EDITIMAGE:
			/*{
				C4DPL_EditImage *editimage = (C4DPL_EditImage*)data;
				if (!data) break;
				if (editimage->return_processed) break;
				GePrint("C4DSDK - Edit Image Hook: "+editimage->imagefn->GetString());
				// editimage->return_processed = true; if image was processed
			}*/
			return false;
	}

	return false;
}
