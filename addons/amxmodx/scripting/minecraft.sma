#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta>
#include <hamsandwich>

#pragma semicolon 1

#define PLUGIN "Minecraft"
#define VERSION "1.0 release"
#define AUTHOR "AkeYlake"

native jbe_get_chief_id();

new g_iBlockSkin, g_iBlock;

new const g_szBlockPath[] = "models/minecraft/block.mdl";
new const g_szLangMenu[][] =
{
	"MC_MENU_BLOCK_CHOOSE_1",
	"MC_MENU_BLOCK_CHOOSE_2",
	"MC_MENU_BLOCK_CHOOSE_3",
	"MC_MENU_BLOCK_CHOOSE_4",
	"MC_MENU_BLOCK_CHOOSE_5",
	"MC_MENU_BLOCK_CHOOSE_6",
	"MC_MENU_BLOCK_CHOOSE_7",
	"MC_MENU_BLOCK_CHOOSE_8",
	"MC_MENU_BLOCK_CHOOSE_9",
	"MC_MENU_BLOCK_CHOOSE_10",
	"MC_MENU_BLOCK_CHOOSE_11",
	"MC_MENU_BLOCK_CHOOSE_12"
};

new const g_szLangFirstMenu[][] =
{
	"MC_MENU_BLOCK_CREATE",
	"MC_MENU_BLOCK_DELETE",
	"MC_MENU_BLOCK_DELETE_ALL",
	"MC_MENU_BLOCK_CHOOSE_SKIN"
};

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_dictionary("minecraft.txt");
	
	register_clcmd("block", "Create_Block");
	register_clcmd("delete", "Delete_Block");
	register_clcmd("ChooseBlock", "Cmd_ChooseBlock");
	register_clcmd("BlockMenu", "Cmd_BlockMenu");
	
	engfunc(EngFunc_PrecacheModel, g_szBlockPath);
	menu_init();
}

menu_init()
{
	register_menucmd(register_menuid("Show_BlockMenu"), (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9), "Handle_BlockMenu");
	register_menucmd(register_menuid("Show_ChooseBlock1Menu"), (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9), "Handle_ChooseBlock1Menu");
	register_menucmd(register_menuid("Show_ChooseBlock2Menu"), (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9), "Handle_ChooseBlock2Menu");
}

public Cmd_BlockMenu(id) return Show_BlockMenu(id);

Show_BlockMenu(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	new szMenu[512], iKeys = (1<<0|1<<1|1<<2|1<<3/*|1<<8*/|1<<9), iLen = formatex(szMenu, charsmax(szMenu), "\y%L^n", id, "MC_MENU_BLOCK_TITLE");
	for(new i = 0; i < sizeof(g_szLangFirstMenu); i++)
	{
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER", i+1, id, g_szLangFirstMenu[i]);
	}
	/*
		Для создания кнопки "назад" надо мод чуть дописать и добавить натив/команду вызова нужного меню.
		Но в принципе можете плагин вмонтировать в мод и просто в 8 кейсе возвращать открытие меню и ничего дописывать не надо будет )0)))))
	*/
//	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER_NINE", id, "MC_MENU_BACK");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n%L \w%L^n", id, "MC_MENU_NUMBER_ZERO", id, "MC_MENU_EXIT");
	
	return show_menu(id, iKeys, szMenu, -1, "Show_BlockMenu");
}

public Handle_BlockMenu(id, iKey)
{
	switch(iKey)
	{
		case 0:
		{
			Create_Block(id);
			return Show_BlockMenu(id);
		}
		case 1:
		{
			Delete_Block(id);
			return Show_BlockMenu(id);
		}
		case 2:
		{
			Delete_Block_all(id);
			return Show_BlockMenu(id);
		}
		case 3:
		{
			return Show_ChooseBlock1Menu(id);
		}
		/*
		case 8:
		{
			return Show_ChiefMenu_2(id);
		}
		*/
		case 9:
		{
			return PLUGIN_HANDLED;
		}
	}
	return Show_BlockMenu(id);
}

public Cmd_ChooseBlock(id) return Show_ChooseBlock1Menu(id);

Show_ChooseBlock1Menu(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	new szMenu[512], iKeys = (1<<8|1<<9), iLen = formatex(szMenu, charsmax(szMenu), "\y%L^n", id, "MC_MENU_BLOCK_CHOOSE_TITLE");
	for(new i = 0; i < sizeof(g_szLangMenu) && i < 8; i++)
	{
		if(i == 7 && sizeof(g_szLangMenu) > 7)
		{
			iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n%L \w%L^n", id, "MC_MENU_NUMBER", i + 1, id, "MC_MENU_NEXT");
			iKeys |= (1<<i);
		}
		else 
		{
			if(g_iBlockSkin != i)
			{
				iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER", i + 1, id, g_szLangMenu[i]);
				iKeys |= (1<<i);
			}
			else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \d%L %L^n", id, "MC_MENU_NUMBER", i + 1, id, g_szLangMenu[i], id, "MC_MENU_USE");
		}
	}

	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER_NINE", id, "MC_MENU_BACK");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER_ZERO", id, "MC_MENU_EXIT");
	
	return show_menu(id, iKeys, szMenu, -1, "Show_ChooseBlock1Menu");
}

public Handle_ChooseBlock1Menu(id, iKey)
{
	switch(iKey)
	{
		case 7:
		{
			if(sizeof(g_szLangMenu) > 7) return Show_ChooseBlock2Menu(id);
			g_iBlockSkin = iKey;
			return Show_ChooseBlock1Menu(id);
		}
		case 8:
		{
			return Show_BlockMenu(id);
		}
		case 9:
		{
			return PLUGIN_HANDLED;
		}
		default:
		{
			g_iBlockSkin = iKey;
			return Show_ChooseBlock1Menu(id);
		}
	}
	return Show_ChooseBlock1Menu(id);
}

Show_ChooseBlock2Menu(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	new szMenu[512], iKeys = (1<<8|1<<9), iLen = formatex(szMenu, charsmax(szMenu), "\y%L^n", id, "MC_MENU_BLOCK_CHOOSE_TITLE");
	
	if(sizeof(g_szLangMenu) > 7)
	{
		for(new i = 7; i < sizeof(g_szLangMenu) && i < 12; i++)
		{
			if(g_iBlockSkin != i)
			{
				iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER", i-6, id, g_szLangMenu[i]);
				iKeys |= (1<<i-7);
			}
			else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \d%L %L^n", id, "MC_MENU_NUMBER", i-6, id, g_szLangMenu[i], id, "MC_MENU_USE");
		}
	}

	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n%L \w%L^n", id, "MC_MENU_NUMBER_NINE", id, "MC_MENU_BACK");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%L \w%L^n", id, "MC_MENU_NUMBER_ZERO", id, "MC_MENU_EXIT");
	
	return show_menu(id, iKeys, szMenu, -1, "Show_ChooseBlock2Menu");
}

public Handle_ChooseBlock2Menu(id, iKey)
{
	switch(iKey)
	{
		case 8:
		{
			return Show_ChooseBlock1Menu(id);
		}
		case 9:
		{
			return PLUGIN_HANDLED;
		}
		default:
		{
			g_iBlockSkin = 7 + iKey;
			return Show_ChooseBlock2Menu(id);
		}
	}
	return Show_ChooseBlock2Menu(id);
}

public Create_Block(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	if(g_iBlock > 100) return PLUGIN_HANDLED;
	
	new iEntity = create_entity("func_breakable");
	if(!pev_valid(iEntity)) return PLUGIN_HANDLED;
	
	g_iBlock++;
	
	set_pev(iEntity, pev_classname, "block"); 
	engfunc(EngFunc_SetModel, iEntity, g_szBlockPath);
	engfunc(EngFunc_SetSize, iEntity, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 30.0});
	engfunc(EngFunc_DropToFloor, iEntity); 

	new iGetBody, iGetEntity;
	new Float:aOrigin[3];
	
	get_user_aiming(id, iGetEntity, iGetBody);
	fm_get_aiming_position(id, aOrigin);
	
	if(isBlock(iGetEntity))
	{
		new Float:bOrigin[3], Float:cOrigin[3];
		new iAxis = 0;
		
		pev(iGetEntity, pev_origin, bOrigin); 
		
		for(new i = 0; i < 3; i++)
		{
			if(bOrigin[i] > aOrigin[i])
			{
				cOrigin[i] = bOrigin[i] - aOrigin[i];
			}
			else
			{
				cOrigin[i] = aOrigin[i] - bOrigin[i];
			}
		}

		if(cOrigin[2] > 30 || cOrigin[2] < 1)
		{
			iAxis = 2;
		}
		else if(cOrigin[0] > cOrigin[1])
		{
			iAxis = 0;
		}
		else
		{
			iAxis = 1;
		}
		
		if(aOrigin[iAxis] > bOrigin[iAxis])
		{
			bOrigin[iAxis] += 30;
		}
		else
		{
			bOrigin[iAxis] -= 30;
		}
		set_pev(iEntity, pev_origin, bOrigin);    
	}
	else
	{
		set_pev(iEntity, pev_origin, aOrigin); 
	}
	
	set_pev(iEntity, pev_solid, SOLID_SLIDEBOX);
	set_pev(iEntity, pev_movetype, MOVETYPE_FLY);
	set_pev(iEntity, pev_health, 1.0);
	set_pev(iEntity, pev_skin, g_iBlockSkin);
	set_pev(iEntity, pev_takedamage, 2.0);
	set_pev(iEntity, pev_nextthink, get_gametime() + 1.0);
	set_pev(iEntity, pev_framerate, 1.0);

	return PLUGIN_HANDLED;
}

public Delete_Block(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	
	new iBody, iEntity;
	static Float:Origin[3], iOrigin[3];
	get_user_origin(id, iOrigin, 3);
	IVecFVec(iOrigin, Origin);
	get_user_aiming(id, iEntity, iBody);

	if(isBlock(iEntity))
	{
		remove_entity(iEntity);
	}
	return PLUGIN_HANDLED;
}

public Delete_Block_all(id)
{
	if(id != jbe_get_chief_id()) return PLUGIN_HANDLED;
	if(g_iBlock > 0)
	{
		new iEntity = -1;
		new const szClassname[] = "block";
		while((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "classname", szClassname)))
		{
			g_iBlock = 0;
			remove_entity(iEntity);
		}
	}
	return PLUGIN_HANDLED;
}

bool:isBlock(iEntity)
{
	if(is_valid_ent(iEntity))
	{
		new szClassname[32];
		entity_get_string(iEntity, EV_SZ_classname, szClassname, 32);

		if(equal(szClassname, "block"))
		{
			return true;
		}
	}
	return false;
}

stock fm_get_aiming_position(pPlayer, Float:vecReturn[3])
{
	new Float:vecOrigin[3], Float:vecViewOfs[3], Float:vecAngle[3], Float:vecForward[3];
	pev(pPlayer, pev_origin, vecOrigin);
	pev(pPlayer, pev_view_ofs, vecViewOfs);
	xs_vec_add(vecOrigin, vecViewOfs, vecOrigin);
	pev(pPlayer, pev_v_angle, vecAngle);
	engfunc(EngFunc_MakeVectors, vecAngle);
	global_get(glb_v_forward, vecForward);
	xs_vec_mul_scalar(vecForward, 8192.0, vecForward);
	xs_vec_add(vecOrigin, vecForward, vecForward);
	engfunc(EngFunc_TraceLine, vecOrigin, vecForward, DONT_IGNORE_MONSTERS, pPlayer, 0);
	get_tr2(0, TR_vecEndPos, vecReturn);
}

stock xs_vec_add(const Float:vec1[], const Float:vec2[], Float:out[])
{
	out[0] = vec1[0] + vec2[0];
	out[1] = vec1[1] + vec2[1];
	out[2] = vec1[2] + vec2[2];
}

stock xs_vec_mul_scalar(const Float:vec[], Float:scalar, Float:out[])
{
	out[0] = vec[0] * scalar;
	out[1] = vec[1] * scalar;
	out[2] = vec[2] * scalar;
}