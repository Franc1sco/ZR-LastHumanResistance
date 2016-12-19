
#include <sourcemod>
#include <sdkhooks>
#include <zombiereloaded>

#define DATA "v1.2.1"

new	Handle:	g_hLastHumans,
			g_iLastHumans;

new	Handle:	g_hLastHumans_Damage,
	Float:	g_iLastHumans_Damage;

public Plugin:myinfo =
{
    name = "[ZR] Last Human Resistance",
    author = "Franc1sco steam: franug",
    description = "For last humans",
    version = DATA,
    url = "http://servers-cfg.foroactivo.com/"
};

public OnPluginStart()
{
	g_hLastHumans = CreateConVar("zr_lasthumans", "1", "Number of humans alive for block infect.");
	g_hLastHumans_Damage = CreateConVar("zr_lasthumans_damage", "20.0", "Damage per hit for the last humans.");
	
	HookConVarChange(g_hLastHumans, OnConVarChanged);
	HookConVarChange(g_hLastHumans_Damage, OnConVarChanged);
	
	g_iLastHumans = GetConVarInt(g_hLastHumans);
	g_iLastHumans_Damage = GetConVarFloat(g_hLastHumans_Damage);
	
	CreateConVar("zr_lasthumanresistance", DATA, "plugin", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
}

public OnConVarChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == g_hLastHumans)
	{
		g_iLastHumans = GetConVarInt(g_hLastHumans);
	}	
	else //if(convar == g_hLastHumans_Damage)
	{
		g_iLastHumans_Damage = GetConVarFloat(g_hLastHumans_Damage);
	}
}


public Action:ZR_OnClientInfect(&client, &attacker, &bool:motherInfect, &bool:respawnOverride, &bool:respawn)
{
	new iHumans = 0;
	for(new i=1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && ZR_IsClientHuman(i))
		{
			iHumans++;
		}
	}
	
	if (iHumans <= g_iLastHumans)
	{
		SDKHooks_TakeDamage(client, attacker, attacker, g_iLastHumans_Damage, DMG_SLASH, -1, NULL_VECTOR, NULL_VECTOR);  
		return Plugin_Handled;
 	}
	
	return Plugin_Continue;
}