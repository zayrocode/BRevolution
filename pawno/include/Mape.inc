#pragma tabsize 0

#if defined _mape_included
    #endinput
#endif
#define _mape_included

#include <streamer> // <--- OVO MORA BITI OVDJE NA VRHU!

///// NEW
new BankaVrata[2];
new BankaLaseri[11];
new BankaTrezorVrata;

stock UkloniMapeObjekte(playerid)
{
       RemoveBuildingForPlayer(playerid, 5024, 1748.8438, -1883.0313, 14.1875, 0.25);
       RemoveBuildingForPlayer(playerid, 5083, 1748.8438, -1883.0313, 14.1875, 0.25);
       RemoveBuildingForPlayer(playerid, 1226, 1526.843, -2190.375, 16.312, 0.250);
       RemoveBuildingForPlayer(playerid, 955, 2060.117, -1897.640, 12.929, 0.250);
       RemoveBuildingForPlayer(playerid, 1340, 388.859, -2071.664, 7.945, 0.250);
    return 1;
}

stock UcitajServerMape()
{
	////////////////////////////////// Spawn Mapa /////////////////////////////////////////////////////////////
	CreateObject(1571, 1569.29407, -2313.68140, 13.58870,   0.00000, 0.00000, 90.00000);
	CreateObject(8650, 1675.66968, -2326.56738, 12.44910,   0.00000, 0.00000, 90.00000);
	CreateObject(8650, 1645.22803, -2326.55640, 12.44910,   0.00000, 0.00000, 90.00000);
	CreateObject(8650, 1614.86621, -2326.54346, 12.44910,   0.00000, 0.00000, 90.00000);
	CreateObject(8650, 1584.62878, -2326.55298, 12.44910,   0.00000, 0.00000, 90.00000);
	CreateObject(8650, 1690.48474, -2342.07593, 12.44910,   0.00000, 0.00000, 0.00000);
	CreateObject(3851, 1690.36108, -2332.16748, 15.54170,   0.00000, 0.00000, 0.00000);
	CreateObject(3851, 1684.72998, -2326.54590, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1673.43982, -2326.53931, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1662.13879, -2326.52271, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1650.84119, -2326.52710, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1639.57043, -2326.51147, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1628.30481, -2326.51343, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1617.02441, -2326.50537, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1605.72290, -2326.50366, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1594.46777, -2326.51611, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1583.20679, -2326.52808, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(3851, 1575.18286, -2326.53320, 15.54170,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.09045, -2314.83081, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.09253, -2303.37500, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.08350, -2296.31396, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.08716, -2296.37769, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(4642, 1540.10107, -2297.57104, 14.24410,   0.00000, 0.00000, 0.00000);
	CreateObject(19425, 1551.56152, -2296.47363, 12.52570,   0.00000, 0.00000, 0.00000);
	CreateObject(19425, 1548.27930, -2296.48462, 12.52570,   0.00000, 0.00000, 0.00000);
	CreateObject(19425, 1544.96631, -2296.49243, 12.52570,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1538.27991, -2296.52148, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1538.27344, -2307.96387, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1538.27319, -2319.50098, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1538.27087, -2328.45044, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.06104, -2333.94385, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.06470, -2345.43164, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.07751, -2356.90674, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1566.09717, -2368.43457, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1554.57373, -2368.40894, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1543.08215, -2368.38770, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1531.60156, -2368.39136, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1520.09998, -2368.38867, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1508.58960, -2368.37720, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1497.09265, -2368.37646, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1495.70422, -2368.36230, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1484.25110, -2356.81860, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1484.25500, -2345.30103, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1484.27454, -2342.27026, 11.22070,   0.00000, 0.00000, 90.00000);
	CreateObject(19912, 1495.67651, -2340.66602, 11.22070,   0.00000, 0.00000, 8.00000);
	CreateObject(19912, 1507.11829, -2340.08765, 11.22070,   0.00000, 0.00000, 3.00000);
	CreateObject(19912, 1518.60864, -2340.09497, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1530.12939, -2340.08154, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(19912, 1538.23840, -2340.09229, 11.22070,   0.00000, 0.00000, 0.00000);
	CreateObject(6965, 1578.04492, -2351.97876, 16.18450,   0.00000, 0.00000, 0.00000);
	CreateObject(6964, 1577.94177, -2351.88916, 12.12920,   0.00000, 0.00000, 0.00000);
	CreateObject(1597, 1548.57141, -2331.40161, 15.09940,   0.00000, 0.00000, 0.00000);
	CreateObject(1597, 1548.50598, -2321.68384, 15.09940,   0.00000, 0.00000, 0.00000);
	CreateObject(1597, 1548.46582, -2311.91626, 15.09940,   0.00000, 0.00000, 0.00000);
	
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2018-12-24 22:37:46" by "Eldin_Fazlic"
	Created by "Eldin_Fazlic"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
new tmpobjid;
tmpobjid = CreateObject(19377, -542.478332, 2591.241210, 9.864540, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.452636, 2591.236328, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -526.973083, 2591.239257, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -526.982421, 2600.837402, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -537.236694, 2600.790771, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -542.475585, 2600.794677, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19370, -542.396118, 2595.975830, 11.735698, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1557, "dave_door_2b", "miragedoor1_256", 0x00000000);
tmpobjid = CreateObject(19377, -521.742614, 2591.254882, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "Televizori", 0, 140, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
tmpobjid = CreateObject(19377, -521.737976, 2600.826660, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.745544, 2586.515625, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -528.159790, 2586.524169, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.589233, 2605.664062, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -527.978820, 2605.658935, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -518.514587, 2605.649169, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -518.920471, 2586.529785, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(18766, -519.695800, 2598.089355, 8.384280, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
tmpobjid = CreateObject(18766, -525.175109, 2593.591064, 8.384300, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
tmpobjid = CreateObject(19370, -538.079650, 2606.631835, 10.840270, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -538.079711, 2606.631835, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19894, -537.049438, 2605.287353, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19370, -521.746276, 2597.997558, 14.140155, 0.000000, 0.000000, -0.100001, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
SetObjectMaterialText(tmpobjid, "Giga", 0, 100, "Ariel", 140, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, -530.856872, 2606.626220, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -530.852172, 2606.598144, 10.840298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -521.751770, 2594.865234, 13.080145, 0.000000, 0.000000, -0.100001, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
SetObjectMaterialText(tmpobjid, "Tron", 0, 100, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
tmpobjid = CreateObject(19370, -537.284912, 2585.697509, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -537.274414, 2585.668457, 10.840298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19377, -537.385131, 2610.366943, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.947998, 2610.370605, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -516.587158, 2600.803955, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -516.593017, 2591.268554, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.395324, 2581.804931, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -536.828796, 2581.804931, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.615600, 2590.651123, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.634277, 2600.960693, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.215087, 2581.789062, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.822265, 2600.790527, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -537.246704, 2591.267822, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -526.844177, 2591.259765, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -537.440551, 2600.841552, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19424, -530.886901, 2605.178710, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "Telefoni", 0, 10, "Ariel", 20, 0, 0x00000000, 0x00000000, 0);
tmpobjid = CreateObject(19377, -542.478332, 2591.241210, 9.864540, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.452636, 2591.236328, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -526.973083, 2591.239257, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -526.982421, 2600.837402, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19377, -537.236694, 2600.790771, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -542.475585, 2600.794677, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19370, -542.396118, 2595.975830, 11.735698, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1557, "dave_door_2b", "miragedoor1_256", 0x00000000);
tmpobjid = CreateObject(19377, -521.742614, 2591.254882, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -521.737976, 2600.826660, 9.852800, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.745544, 2586.515625, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -528.159790, 2586.524169, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -537.589233, 2605.664062, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -527.978820, 2605.658935, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -518.514587, 2605.649169, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19377, -518.920471, 2586.529785, 9.864500, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(18766, -519.695800, 2598.089355, 8.384280, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
tmpobjid = CreateObject(18766, -525.175109, 2593.591064, 8.384300, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
tmpobjid = CreateObject(19370, -538.079650, 2606.631835, 10.840270, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -538.079711, 2606.631835, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19894, -537.049438, 2605.287353, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99CC99);
tmpobjid = CreateObject(19370, -538.081359, 2605.663085, 12.980126, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
SetObjectMaterialText(tmpobjid, "Laptopi", 0, 140, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
tmpobjid = CreateObject(19370, -530.856872, 2606.626220, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -530.852172, 2606.598144, 10.840298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -530.834411, 2605.654541, 12.920152, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19468, "bucket01", "bucket01", 0x00000000);
SetObjectMaterialText(tmpobjid, "Slusalice", 0, 140, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
tmpobjid = CreateObject(19370, -537.284912, 2585.697509, 11.560298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -537.274414, 2585.668457, 10.840298, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateObject(19370, -537.142395, 2586.520019, 12.960132, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "Telefoni", 0, 140, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
tmpobjid = CreateObject(19377, -537.385131, 2610.366943, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.947998, 2610.370605, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -516.587158, 2600.803955, 12.410868, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -516.593017, 2591.268554, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.395324, 2581.804931, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -536.828796, 2581.804931, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.615600, 2590.651123, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.634277, 2600.960693, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -547.215087, 2581.789062, 12.410900, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19377, -526.822265, 2600.790527, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -537.246704, 2591.267822, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -526.844177, 2591.259765, 15.029198, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFCCCC);
tmpobjid = CreateObject(19377, -537.440551, 2600.841552, 9.901598, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "ceilingtiles4-128x128", 0x00000000);
tmpobjid = CreateObject(19370, -529.781616, 2586.530029, 13.690134, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "Televizori", 0, 140, "Ariel", 140, 0, 0xFFFFFF33, 0x00000000, 1);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateObject(19893, -539.232666, 2605.220458, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19893, -538.161437, 2605.225341, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19893, -537.001342, 2605.219726, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19894, -539.191040, 2605.272705, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19894, -538.151000, 2605.272705, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2008, -525.132629, 2595.494873, 10.062600, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2894, -525.023315, 2594.436767, 10.882300, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(19424, -532.023864, 2605.249023, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -531.001403, 2605.230712, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -529.950073, 2605.246582, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -532.011596, 2605.202636, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -529.732727, 2605.187255, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -532.609619, 2608.298828, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -529.088623, 2608.255615, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -536.323913, 2608.215332, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -539.842834, 2608.271728, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19370, -523.419799, 2604.062744, 10.080698, 0.000000, 90.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(11711, -542.400024, 2595.943603, 13.721598, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(19609, -523.516113, 2603.923828, 10.165900, 0.000000, 0.000000, -45.000000, 300.00); 
tmpobjid = CreateObject(19325, -535.512756, 2584.055908, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -539.044372, 2584.027099, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.138000, 2587.016357, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.185974, 2587.006591, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -538.385559, 2587.052978, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.059692, 2587.004638, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.227111, 2586.983642, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -538.533752, 2586.974609, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.868469, 2586.998291, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.623535, 2586.992431, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.622131, 2586.997314, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.804931, 2587.017089, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(19787, -532.464965, 2586.559326, 12.367544, 0.000000, 0.000000, 179.799957, 300.00); 
tmpobjid = CreateObject(19787, -527.253845, 2586.544433, 12.317543, 0.000000, 0.000000, 179.799957, 300.00); 
tmpobjid = CreateObject(19786, -529.895568, 2586.504882, 12.407525, 0.000000, 0.000000, -179.900039, 300.00); 
tmpobjid = CreateObject(1671, -523.525268, 2594.232666, 10.437546, 0.000000, 0.000000, -108.100006, 300.00); 
tmpobjid = CreateObject(1886, -541.985351, 2605.088623, 15.019978, 25.200010, 0.000000, 47.099960, 300.00); 
tmpobjid = CreateObject(1886, -541.714904, 2587.061767, 15.039513, 25.200010, 0.000000, 137.900039, 300.00); 
tmpobjid = CreateObject(1886, -522.398315, 2605.007324, 14.970314, 25.200010, 0.000000, -47.099994, 300.00); 
tmpobjid = CreateObject(1886, -522.381713, 2587.171630, 15.055826, 25.200010, 0.000000, -141.199981, 300.00); 
tmpobjid = CreateObject(19893, -539.232666, 2605.220458, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19893, -538.161437, 2605.225341, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19893, -537.001342, 2605.219726, 10.924698, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19894, -539.191040, 2605.272705, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19894, -538.151000, 2605.272705, 11.647548, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2008, -525.132629, 2595.494873, 10.062600, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2894, -525.023315, 2594.436767, 10.882300, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(19424, -532.023864, 2605.249023, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -531.001403, 2605.230712, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -529.950073, 2605.246582, 11.648598, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -532.011596, 2605.202636, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -530.886901, 2605.178710, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19424, -529.732727, 2605.187255, 10.927848, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -532.609619, 2608.298828, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -529.088623, 2608.255615, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -536.323913, 2608.215332, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -539.842834, 2608.271728, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19370, -523.419799, 2604.062744, 10.080698, 0.000000, 90.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(11711, -542.400024, 2595.943603, 13.721598, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(19609, -523.516113, 2603.923828, 10.165900, 0.000000, 0.000000, -45.000000, 300.00); 
tmpobjid = CreateObject(19325, -535.512756, 2584.055908, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19325, -539.044372, 2584.027099, 9.992198, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.138000, 2587.016357, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.185974, 2587.006591, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -538.385559, 2587.052978, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.059692, 2587.004638, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.227111, 2586.983642, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -538.533752, 2586.974609, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.868469, 2586.998291, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.623535, 2586.992431, 10.967800, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -536.622131, 2586.997314, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(18869, -537.804931, 2587.017089, 11.688098, 62.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(19787, -532.464965, 2586.559326, 12.367544, 0.000000, 0.000000, 179.799957, 300.00); 
tmpobjid = CreateObject(19787, -527.253845, 2586.544433, 12.317543, 0.000000, 0.000000, 179.799957, 300.00); 
tmpobjid = CreateObject(19786, -529.895568, 2586.504882, 12.407525, 0.000000, 0.000000, -179.900039, 300.00); 
tmpobjid = CreateObject(1671, -523.525268, 2594.232666, 10.437546, 0.000000, 0.000000, -108.100006, 300.00); 
tmpobjid = CreateObject(1886, -541.985351, 2605.088623, 15.019978, 25.200010, 0.000000, 47.099960, 300.00); 
tmpobjid = CreateObject(1886, -541.714904, 2587.061767, 15.039513, 25.200010, 0.000000, 137.900039, 300.00); 
tmpobjid = CreateObject(1886, -522.398315, 2605.007324, 14.970314, 25.200010, 0.000000, -47.099994, 300.00); 
tmpobjid = CreateObject(1886, -522.381713, 2587.171630, 15.055826, 25.200010, 0.000000, -141.199981, 300.00); 

//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2018-07-19 14:48:18" by "Rile"
	Created by "Rile"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19447, 1789.952148, -1308.374633, 110.086303, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4550, "skyscr1_lan2", "gm_labuld2_b", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 616.196228, -1512.010986, 0.174199, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 615.577575, -1516.634765, 0.057900, 0.000000, 0.000000, 73.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 615.541015, -1507.371948, 0.057900, 0.000000, 0.000000, 107.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 609.260314, -1515.240112, 0.482100, 90.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 609.215881, -1508.767944, 0.482100, 90.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(14411, 611.317871, -1513.337158, -1.421700, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampblack", 0x00000000);
tmpobjid = CreateDynamicObjectEx(14411, 611.308227, -1509.381835, -1.421700, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampblack", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 607.579101, -1519.976928, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 602.834472, -1524.714111, 3.542098, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 598.058532, -1519.963378, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 607.550292, -1504.005615, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 602.807739, -1499.271606, 3.542098, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 598.049804, -1510.367797, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19383, 598.057678, -1500.788085, 3.554800, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 598.044311, -1506.390014, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.843078, -1519.542968, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.786071, -1509.061401, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.823669, -1498.606079, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.214843, -1498.619995, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.213562, -1509.091674, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.198608, -1519.552124, 1.694200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 593.286315, -1499.272460, 3.542098, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 588.524108, -1504.005126, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 588.526672, -1513.622802, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 593.234008, -1524.709228, 3.542098, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 588.521972, -1519.952758, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 597.892944, -1506.392944, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 597.901733, -1516.005249, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19447, 597.893249, -1525.553100, 3.542098, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.095825, -1521.581054, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 604.758361, -1521.587402, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 603.265075, -1521.588623, 1.960500, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 601.590270, -1521.584960, 1.960500, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.038391, -1516.276855, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.026794, -1514.773925, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.019042, -1513.448364, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.022094, -1512.568969, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.041687, -1505.216186, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.006408, -1511.107055, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.016113, -1508.883422, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 599.999755, -1510.420043, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.055297, -1507.438964, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 600.052612, -1506.420898, 1.960500, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 601.568969, -1501.701538, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 605.273559, -1501.699951, 1.840499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampred", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 602.866821, -1501.696533, 1.960500, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(9131, 603.892150, -1501.691162, 1.960500, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(1360, 606.912597, -1518.794799, 2.519299, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4550, "skyscr1_lan2", "gm_labuld2_b", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.316711, -1519.528808, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.334960, -1509.217529, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 593.299194, -1498.893798, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.773620, -1504.424072, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.750000, -1514.853637, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 602.811584, -1525.155029, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 612.196166, -1511.339233, 5.154200, 0.000000, 90.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 8395, "pyramid", "luxorwindow01_128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, 616.139038, -1512.012329, 0.057900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "sjmhoodaac", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19383, 597.887512, -1500.788085, 3.554800, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 5267, "lashops91_las2", "laspowrec2", 0x00000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19799, 588.520996, -1522.253662, 3.265000, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.476623, -1521.301391, 4.159998, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.548400, -1521.297363, 3.220000, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.483886, -1522.153564, 4.159998, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.481811, -1522.989624, 4.159998, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.484619, -1523.838256, 4.159998, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 596.852783, -1524.500732, 4.159998, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 596.013671, -1524.513671, 4.159998, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 595.159484, -1524.516723, 4.159998, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 594.298706, -1524.526245, 4.159998, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.523376, -1522.163574, 3.220000, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.504577, -1523.014160, 3.220000, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.508605, -1523.836181, 3.220000, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 596.854675, -1524.583007, 3.220000, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 595.997802, -1524.562988, 3.220000, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 595.164794, -1524.562133, 3.220000, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 594.303894, -1524.553955, 3.220000, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1829, 597.240417, -1521.285400, 2.261600, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19618, 595.169189, -1524.388305, 2.261600, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.333679, -1524.551025, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.070068, -1524.567626, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.334350, -1524.369873, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.073547, -1524.376953, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.321105, -1524.511962, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.057922, -1524.511840, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.065612, -1524.330810, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 595.308959, -1524.327880, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19618, 594.318542, -1524.383178, 2.261600, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.454833, -1524.559204, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.465148, -1524.374877, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.168945, -1524.544677, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.182495, -1524.380126, 2.277488, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.446594, -1524.489501, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.164062, -1524.494506, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.154663, -1524.313476, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 594.440490, -1524.328125, 1.917500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.583435, -1522.164916, 2.261600, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.564086, -1523.037231, 2.261600, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 597.563476, -1523.889892, 2.261600, 0.000000, 0.000000, -91.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 596.854675, -1524.583007, 2.261600, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2332, 595.997802, -1524.562988, 2.261600, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1828, 595.108886, -1522.573974, 1.781800, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2165, 590.700012, -1501.835815, 1.779600, 0.000000, 0.000000, 205.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1714, 589.676147, -1500.642211, 1.780619, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1502, 598.113586, -1501.526367, 1.781100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 602.471679, -1521.188598, 1.280598, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 602.469299, -1522.009643, 1.280598, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.922485, -1521.556640, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.662414, -1521.548706, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.401672, -1521.560791, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.101196, -1521.553955, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 602.861450, -1521.564697, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 604.194580, -1521.563598, 2.338299, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 602.490600, -1521.555786, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 602.250427, -1521.546997, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 601.990234, -1521.557495, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 601.729858, -1521.567993, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 601.450012, -1521.557861, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 601.169860, -1521.567626, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.889709, -1521.577392, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.589599, -1521.586425, 2.438199, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 600.425903, -1514.408203, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 600.422607, -1510.723266, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 600.439392, -1507.048706, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 599.608154, -1510.754760, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 599.603271, -1507.051757, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 599.611328, -1514.423828, 1.280598, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.037841, -1515.746337, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.029296, -1515.466064, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.021362, -1515.205810, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.033447, -1514.944946, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.045532, -1514.684082, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.057617, -1514.423217, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.068237, -1514.142333, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.059509, -1513.882080, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.070068, -1513.601074, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.060668, -1513.320800, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.051940, -1513.060546, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.045043, -1512.074096, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.050903, -1511.833862, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.046875, -1511.553588, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.046264, -1511.313110, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.047363, -1511.092285, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.046691, -1510.851806, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.044372, -1510.591308, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.046447, -1510.309936, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.048400, -1510.030029, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.050415, -1509.750122, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.053710, -1509.490112, 2.437798, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.068786, -1508.400268, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.070739, -1508.147338, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.073913, -1507.875366, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.063720, -1507.595214, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.074157, -1507.334228, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.064025, -1507.054199, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.073852, -1506.773437, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.085021, -1506.532470, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.075805, -1506.272827, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.087097, -1506.032104, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 600.076843, -1505.751831, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.051513, -1512.617553, 3.084000, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.076110, -1508.933349, 3.084000, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.081970, -1505.210083, 3.084000, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.074890, -1516.317260, 3.084000, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 604.811706, -1521.577758, 3.084000, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 600.111267, -1521.521118, 3.084000, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 603.419921, -1502.083496, 1.280598, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1649, 603.399597, -1501.275756, 1.280598, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 601.544738, -1501.752929, 3.084000, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2710, 605.245300, -1501.740112, 3.084000, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 602.130310, -1501.646850, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 602.427246, -1501.642822, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 602.708068, -1501.642211, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.008544, -1501.652954, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.271240, -1501.640136, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.491455, -1501.645507, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 603.751464, -1501.651733, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 604.031616, -1501.658569, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 604.291625, -1501.664916, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 604.571716, -1501.671752, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19941, 604.791809, -1501.677001, 2.337660, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1360, 606.827209, -1505.193847, 2.519299, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1557, 616.119995, -1512.843383, 0.239198, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(646, 614.912475, -1515.441284, 1.539100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(646, 615.035644, -1508.252319, 1.539100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(646, 607.513244, -1509.338989, 3.119100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(646, 607.478942, -1514.531494, 3.119100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, -1525.737670, -12101.114257, -451.721099, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, -1525.737670, -12101.114257, -451.601104, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 591.788146, -1524.354858, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 591.249450, -1524.370117, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 590.695922, -1524.361328, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 590.190612, -1524.322998, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 589.617736, -1524.309570, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 589.001281, -1524.306274, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1550, 597.484008, -1520.499267, 2.140700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19173, 588.624084, -1512.351196, 3.588700, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19174, 593.351318, -1499.367797, 3.898699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19173, 598.141235, -1511.276123, 3.588700, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19175, 603.318420, -1499.398193, 3.859600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
//////////////////////////////////////////Bolnica //////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2018-07-27 18:37:51" by "Rile"
	Created by "Rile"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19454, -25.066499, 1501.035522, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -20.303560, 1505.760009, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -10.673210, 1505.749633, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -5.955100, 1501.009521, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19433, -7.477469, 1499.336669, -3.994100, 90.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "wood051", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -11.145199, 1501.000976, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19433, -9.524439, 1501.300781, -3.994100, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "wood051", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19386, -9.520389, 1504.513183, -2.592499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "wood051", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -21.557699, 1501.023681, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -5.959410, 1491.454956, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -11.151240, 1491.440673, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -21.507919, 1491.453491, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -22.024629, 1491.544677, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -20.339370, 1486.787719, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19385, -15.590089, 1491.507202, -2.574700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -15.580599, 1494.651245, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -15.577249, 1488.337646, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -20.373559, 1496.285156, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -17.195350, 1496.286865, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -23.478759, 1496.290649, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -11.133830, 1481.870483, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -5.955989, 1481.869140, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -7.733799, 1482.374145, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -15.557880, 1482.007080, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -7.612899, 1473.867431, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -11.128780, 1472.236083, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -25.935670, 1474.012207, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -15.553489, 1475.607910, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -5.976689, 1475.533203, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19385, -12.467639, 1478.565673, -2.574700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -12.458999, 1480.853393, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -12.467499, 1475.353515, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -5.933949, 1472.251708, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -2.815779, 1472.300292, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19385, -5.934309, 1469.880737, -2.574700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -2.814440, 1469.129882, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -5.933219, 1467.561889, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -10.138299, 1467.746948, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -7.274640, 1467.760986, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -4.159659, 1467.454956, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -20.787220, 1467.730224, -2.580600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -21.525899, 1472.303222, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -22.113109, 1469.259033, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -22.126430, 1472.360351, -2.574100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19385, -19.795120, 1474.051879, -2.574700, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19362, -17.074579, 1474.058715, -2.574100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -25.098960, 1482.091674, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19454, -25.111820, 1472.547851, -2.580600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -21.519910, 1481.905883, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2610, -24.610010, 1475.293457, -4.271500, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-20-percent", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -19.902889, 1501.058959, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -9.560279, 1501.059814, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -16.835790, 1491.571166, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -6.702380, 1491.597290, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -6.701220, 1482.007202, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -17.126239, 1482.007202, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -27.349519, 1481.991821, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -6.695370, 1472.488037, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -17.128839, 1472.471435, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -27.240629, 1472.510498, -1.059100, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(3440, -9.491800, 1499.315429, -2.774600, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3857, -9.597629, 1502.825195, 1.072999, 0.000000, 0.000000, -45.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3857, -5.886489, 1499.548339, 1.072999, 0.000000, 0.000000, 47.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1502, -9.540450, 1505.288818, -4.352399, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1557, -25.028390, 1499.342529, -4.303899, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1557, -25.025630, 1502.304565, -4.303899, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2008, -9.019700, 1501.153686, -4.311200, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1999, -7.085000, 1499.878295, -4.319799, 0.000000, 0.000000, -900.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1806, -8.225270, 1501.884033, -4.310900, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1806, -7.853579, 1500.587524, -4.310900, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -20.422199, 1505.278442, -3.852699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -16.786909, 1505.282592, -3.852699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -20.975870, 1500.682861, -3.852699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -21.776149, 1496.867431, -3.852699, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -18.103469, 1496.874877, -3.852699, 0.000000, 0.000000, 180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -17.385400, 1500.673095, -3.852699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -13.712679, 1500.669067, -3.852699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3034, -22.959909, 1505.636596, -2.326100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3034, -14.093939, 1505.633911, -2.326100, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -24.374629, 1496.839721, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -24.430749, 1505.173583, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1808, -11.838850, 1505.505493, -4.346899, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1502, -15.605804, 1492.289794, -4.352399, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -9.103630, 1503.353759, -3.491499, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2161, -6.040510, 1501.777832, -4.351099, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -6.056809, 1503.575927, -4.311500, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2165, -20.022119, 1492.083984, -4.312399, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1714, -21.144590, 1491.831542, -4.332099, 0.000000, 0.000000, 52.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -6.459899, 1495.818969, -3.852699, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -6.453750, 1492.176879, -3.852699, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1557, -5.992939, 1485.174438, -4.303899, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1557, -5.997109, 1488.150756, -4.303899, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -15.136019, 1494.617553, -3.852699, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -15.079839, 1488.116455, -3.852699, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -10.123740, 1492.177978, -3.852699, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -10.113450, 1495.868652, -3.852699, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -10.948900, 1495.872924, -3.852699, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3657, -10.954669, 1492.172119, -3.852699, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -20.070489, 1496.140502, -4.311500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -18.288349, 1496.142944, -4.311500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -20.105199, 1486.940185, -4.311500, 0.000000, 0.000000, 179.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -21.163249, 1495.583374, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -21.379959, 1488.343017, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1523, -12.496569, 1474.074829, -4.311999, 0.000000, 0.000000, 179.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1523, -15.511460, 1474.025390, -4.312479, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1502, -12.521149, 1479.368774, -4.352399, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(638, -9.185330, 1482.794189, -3.632800, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -11.438220, 1482.998901, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(630, -6.992489, 1483.080322, -3.293499, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2296, -6.344470, 1476.804565, -4.313499, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1999, -7.127810, 1479.699340, -4.319799, 0.000000, 0.000000, -234.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1714, -6.483689, 1480.843017, -4.332099, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1704, -11.683679, 1475.598632, -4.312200, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -11.793479, 1482.277709, -4.311500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2164, -10.047550, 1482.283203, -4.311500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1812, -16.351640, 1489.717407, -4.311999, 0.000000, 0.000000, -180.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1495, -5.903210, 1469.141845, -4.311100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19377, -0.670159, 1472.239257, -4.399099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(18755, -13.848199, 1465.937866, -2.414200, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3383, -4.317430, 1470.048339, -4.312399, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3092, -4.395999, 1469.841918, -3.058099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1523, -20.611129, 1473.999755, -4.312479, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -18.388570, 1468.126953, -4.312399, 0.000000, 0.000000, 177.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -19.431640, 1468.130981, -4.312399, 0.000000, 0.000000, 177.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -20.532899, 1468.160156, -4.312399, 0.000000, 0.000000, 177.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -21.491699, 1468.211669, -4.312399, 0.000000, 0.000000, 177.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -21.735469, 1470.008422, -4.312399, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -21.782829, 1471.265380, -4.312399, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11729, -21.714040, 1472.640747, -4.312399, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1369, -6.565299, 1472.849975, -3.712500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1369, -8.346050, 1472.742431, -3.712500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1369, -9.972450, 1472.736328, -3.712500, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1808, -6.269360, 1477.880615, -4.346899, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1808, -21.768180, 1490.254150, -4.346899, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -23.790090, 1476.682495, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -23.812309, 1479.703125, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -23.839170, 1482.893920, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -23.854219, 1486.174926, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -16.905860, 1476.696533, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -16.919639, 1479.644653, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -16.950700, 1483.140991, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2603, -16.863630, 1486.099121, -3.853600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -24.721099, 1484.909423, -4.271500, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -24.679199, 1481.426513, -4.271500, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -24.624469, 1478.139648, -4.271500, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -16.033409, 1474.986083, -4.271500, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -16.124750, 1478.175781, -4.271500, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -16.032390, 1481.595092, -4.271500, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(2610, -16.076150, 1484.695190, -4.271500, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3034, -6.093279, 1493.478759, -2.326100, 0.000000, 0.000000, 270.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3034, -24.991880, 1484.140136, -2.326100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3034, -24.959619, 1477.616210, -2.326100, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
//////////////////////////////////////// Taxi Baza //////////////////////////////////////////////////////////////////////
CreateObject(970, 1811.59216, -1896.99536, 13.09340,   0.00000, 0.00000, 90.00000);
CreateObject(970, 1810.32947, -1882.21069, 13.09340,   0.00000, 0.00000, 90.00000);
CreateObject(4642, 1809.80322, -1883.49817, 14.23610,   0.00000, 0.00000, 0.00000);
CreateObject(19425, 1811.77771, -1892.83252, 12.51910,   0.00000, 0.00000, 90.00000);
CreateObject(19425, 1811.77612, -1889.57593, 12.51910,   0.00000, 0.00000, 90.00000);
CreateObject(19425, 1811.77539, -1886.32007, 12.51910,   0.00000, 0.00000, 90.00000);
//////////////////////////////////////////////////Parkibng Servis////////////////////////////////////////////////////////////
CreateObject(18766, 1019.15961, -907.86511, 43.66070,   0.00000, 0.00000, 97.00000);
CreateObject(18766, 1017.94080, -898.01563, 43.66070,   0.00000, 0.00000, 97.00000);
CreateObject(18766, 1016.74274, -888.44916, 43.66070,   0.00000, 0.00000, 97.00000);
CreateObject(985, 1071.65002, -922.67682, 42.18000,   0.00000, 0.00000, 27.00000);
CreateObject(18766, 1073.61255, -869.43073, 45.04070,   0.00000, 0.00000, 97.00000);


///////////////////////////////////////////////MJENACNICA/////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19455, 1293.750854, -942.136230, 39.092700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(18766, 1293.550170, -944.547485, 40.372001, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "carlot1_sfw", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(18766, 1293.531005, -949.322937, 40.372001, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "carlot1_sfw", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19455, 1298.479858, -946.994628, 39.092700, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19455, 1298.468017, -946.871398, 42.572700, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19455, 1293.748291, -951.760314, 42.572700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19455, 1289.030395, -946.904724, 42.572700, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19391, 1293.682983, -942.195983, 42.569000, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19358, 1296.834960, -942.167602, 42.566898, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19358, 1290.513793, -942.182067, 42.566898, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "officewallsnew1", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(18766, 1293.531005, -949.322875, 44.131999, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(18766, 1293.550170, -944.607482, 44.131999, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "BLUE_FABRIC", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(2165, 1292.892944, -948.944519, 40.869300, 0.000000, 0.000000, 3.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "carlot1_sfw", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(14407, 1293.646118, -939.831604, 37.656200, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19358, 1295.582763, -941.276916, 39.106899, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);

    tmpobjid = CreateDynamicObjectEx(19358, 1291.662109, -941.254089, 39.106899, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);

    CreateDynamicObjectEx(2165, 1295.902343, -948.707031, 40.869300, 0.000000, 0.000000, 3.000000, 300.00, 300.00);
    CreateDynamicObjectEx(2165, 1290.035400, -949.065979, 40.869300, 0.000000, 0.000000, 3.000000, 300.00, 300.00);

    CreateDynamicObjectEx(1671, 1296.988403, -950.349243, 41.330398, 0.000000, 0.000000, 900.000000, 300.00, 300.00);
    CreateDynamicObjectEx(1671, 1293.583007, -950.545593, 41.330398, 0.000000, 0.000000, 900.000000, 300.00, 300.00);
    CreateDynamicObjectEx(1671, 1290.512329, -950.454833, 41.330398, 0.000000, 0.000000, 900.000000, 300.00, 300.00);

    CreateDynamicObjectEx(1724, 1297.597900, -944.739379, 40.869701, 0.000000, 0.000000, -90.000000, 300.00, 300.00);
    CreateDynamicObjectEx(1724, 1290.401367, -945.960388, 40.869701, 0.000000, 0.000000, 90.000000, 300.00, 300.00);

    CreateDynamicObjectEx(1491, 1292.881225, -942.170654, 40.802757, 0.000000, 0.000000, 0.000000, 300.00, 300.00);


/////////////////////////////////////////////////////BANKA///////////////////////////////////////////////////////////////////////
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2018-12-13 14:38:53" by "Rile"
	Created by "Rile"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateObject(19377, 154.742401, 1702.590576, 0.095499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19370, 154.710006, 1702.720214, -0.108400, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1557, "dave_door_2b", "miragedoor1_256", 0x00000000);
tmpobjid = CreateObject(19377, 149.341094, 1702.826660, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 138.856033, 1702.835083, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19370, 143.760192, 1705.762817, -0.168400, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19370, 143.760208, 1699.369873, -0.178399, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19428, 143.770278, 1702.553222, 1.772529, 90.900039, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 150.006744, 1707.352905, 0.043460, -0.600000, 0.000000, 90.600028, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 148.507019, 1707.333251, 0.027750, -0.600000, 0.000000, 90.600028, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 148.606491, 1697.880615, 0.027750, -0.600000, 0.000000, 90.600028, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 149.936294, 1697.896240, 0.041680, -0.600000, 0.000000, 90.600028, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 143.752365, 1712.071655, -0.164499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 139.029037, 1713.509887, -0.210292, -0.600000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 134.242706, 1711.951660, -0.264499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 138.856033, 1712.207153, -1.934499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 128.495971, 1702.845092, -1.934499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 128.496414, 1712.207153, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 129.505706, 1713.570190, -0.281292, -0.200000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 124.512664, 1711.861694, -0.154499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 143.752365, 1693.079345, -0.174500, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 128.495971, 1693.250976, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 138.846038, 1693.263793, -1.954499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19370, 136.297515, 1707.258544, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1649, "wglass", "carshowwin2", 0x00000000);
tmpobjid = CreateObject(19370, 142.072113, 1707.425415, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1649, "wglass", "carshowwin2", 0x00000000);
tmpobjid = CreateObject(19428, 139.028564, 1707.369750, 1.735499, 90.000000, 0.000000, -87.500000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19370, 132.076553, 1707.185668, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1649, "wglass", "carshowwin2", 0x00000000);
tmpobjid = CreateObject(19370, 126.205772, 1707.138793, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 1649, "wglass", "carshowwin2", 0x00000000);
tmpobjid = CreateObject(19428, 129.410202, 1707.122070, 1.584400, 90.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 139.012100, 1688.354003, -0.134499, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 129.417800, 1688.358032, -0.134499, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 119.776260, 1707.133422, -0.134499, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 119.771743, 1702.888671, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19377, 118.002471, 1693.259765, -1.944499, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_kitchfloor", 0x00000000);
tmpobjid = CreateObject(19385, 119.848297, 1688.350341, -0.140599, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19370, 123.052856, 1688.355346, -0.138400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19370, 116.641197, 1688.350219, -0.138400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 115.007499, 1693.070556, -0.134499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 115.003730, 1702.613281, -0.134499, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_wall", 0x00000000);
tmpobjid = CreateObject(19377, 119.567413, 1693.055541, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(18980, 122.385536, 1703.953369, -1.099900, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18996, "mattextures", "wood020", 0x00000000);
tmpobjid = CreateObject(18980, 134.198059, 1707.215942, -4.860099, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
tmpobjid = CreateObject(18980, 143.389602, 1688.697753, -4.860099, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk5-128x128", 0x00000000);
tmpobjid = CreateObject(18980, 122.404876, 1703.958862, -1.439900, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18996, "mattextures", "wood020", 0x00000000);
tmpobjid = CreateObject(19428, 122.463386, 1705.442138, -0.602100, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19428, 122.459083, 1701.989379, -0.602100, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19428, 122.450447, 1698.520507, -0.602100, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19428, 122.448348, 1695.050048, -0.602100, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19428, 122.443389, 1692.890014, -0.602100, 0.000000, 90.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19087, 122.680732, 1695.836914, 1.924900, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19087, 122.685111, 1700.945312, 1.924900, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19370, 122.601699, 1698.658325, 0.911600, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
SetObjectMaterialText(tmpobjid, "SALTER 2", 0, 100, "Ariel", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 122.564292, 1697.428222, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.567863, 1700.615844, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.567588, 1703.781127, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.559913, 1706.922485, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.598457, 1692.906982, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19087, 122.717613, 1691.386108, 1.924900, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19087, 122.800491, 1706.866943, 1.924900, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
tmpobjid = CreateObject(19428, 120.552902, 1700.981567, -1.522099, 90.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
tmpobjid = CreateObject(19428, 120.585662, 1695.888793, -1.522099, 90.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
tmpobjid = CreateObject(19428, 148.089630, 1706.778930, -1.572499, 0.899999, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateObject(19428, 150.580718, 1706.823608, -1.572499, 0.899999, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateObject(19428, 151.297363, 1698.476928, -1.572499, 0.899999, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateObject(19428, 148.634643, 1698.370117, -1.572499, 0.899999, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateObject(19377, 119.566703, 1702.625244, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 129.928680, 1702.689819, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 129.908172, 1693.141601, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 140.324890, 1693.088623, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 140.370773, 1702.682006, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 149.840026, 1702.612548, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 139.876647, 1711.943359, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(19377, 129.528121, 1712.107055, 1.575500, 0.000000, 90.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
tmpobjid = CreateObject(1232, 129.254867, 1710.018188, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 3267, "milbase", "lightblue_64", 0x00000000);
tmpobjid = CreateObject(19428, 123.989402, 1695.842285, -2.342099, 129.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19428, 124.014396, 1700.897094, -2.342099, 129.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.591598, 1694.267211, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
tmpobjid = CreateObject(19370, 122.601699, 1704.070678, 0.911600, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
SetObjectMaterialText(tmpobjid, "SALTER 3", 0, 100, "Ariel", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 126.203102, 1707.008911, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "MOJ", 0, 100, "Calibri", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 132.180435, 1707.086791, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "BANKAR", 0, 100, "Engravers MT", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 136.228927, 1707.127929, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "MOJ", 0, 100, "Ariel", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 142.111831, 1707.365112, -0.108400, 0.000000, 0.000000, 90.000000, 300.00); 
SetObjectMaterialText(tmpobjid, "BANKAR", 0, 100, "Ariel", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateObject(19370, 122.591598, 1694.267211, 2.131599, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
SetObjectMaterialText(tmpobjid, "SALTER 1", 0, 60, "Ariel", 20, 0, 0xFFFFFFFF, 0x00000000, 0);
tmpobjid = CreateObject(19370, 122.601699, 1693.817016, 0.911600, 0.000000, 0.000000, 0.000000, 300.00); 
SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
SetObjectMaterialText(tmpobjid, "SALTER 1", 0, 100, "Ariel", 60, 0, 0xFFFFFFFF, 0x00000000, 1);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateObject(14576, 116.192062, 1703.058593, -6.240699, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1536, 121.882202, 1685.750976, -67734.000000, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(19366, 121.935096, 1686.605224, -5.053100, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19366, 120.216987, 1688.377197, -5.053100, 0.000000, 0.000000, 90.000000, 300.00); 
BankaVrata[0] = CreateObject(19302, 115.434486, 1690.312866, -13.214599, 0.000000, 0.000000, 0.000000, 300.00); 
BankaVrata[1] = CreateObject(19302, 117.156379, 1690.316406, -13.214599, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(19304, 116.273902, 1690.353759, -11.414999, 0.000000, 0.000000, 0.000000, 300.00); 
BankaTrezorVrata = CreateObject(2634, 116.217002, 1710.814819, -12.734299, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(1829, 116.193572, 1725.973144, -13.935600, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 117.061698, 1726.267700, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 117.903846, 1726.273315, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 118.726089, 1726.277709, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 115.344192, 1726.225708, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 114.503326, 1726.238403, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2332, 113.665756, 1726.230712, -13.913800, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[0] = CreateObject(19081, 111.482551, 1699.059448, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[1] = CreateObject(19081, 98.291610, 1694.641845, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[2] = CreateObject(19081, 110.973747, 1703.201538, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[3] = CreateObject(19081, 111.188209, 1707.675659, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[4] = CreateObject(19081, 95.661483, 1703.211669, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[5] = CreateObject(19081, 99.131156, 1707.675537, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[6] = CreateObject(19081, 92.812393, 1699.049682, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[7] = CreateObject(19081, 111.734542, 1694.640747, -13.465020, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[8] = CreateObject(19081, 106.252601, 1695.864257, -13.944999, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[9] = CreateObject(19081, 105.915420, 1700.942138, -13.944999, 0.000000, 0.000000, 0.000000, 300.00); 
BankaLaseri[10] = CreateObject(19081, 104.662940, 1706.284790, -13.944999, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19305, 118.117103, 1689.235473, -12.858300, 0.000000, 0.000000, 269.000000, 300.00); 
tmpobjid = CreateObject(19305, 117.562538, 1710.558837, -13.066470, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2165, 121.286926, 1694.163330, -1.856899, 0.000000, 0.000000, 270.000000, 300.00); 
tmpobjid = CreateObject(2165, 121.123001, 1698.910400, -1.856899, 0.000000, 0.000000, 270.000000, 300.00); 
tmpobjid = CreateObject(2165, 121.248641, 1704.689941, -1.856899, 0.000000, 0.000000, 270.000000, 300.00); 
tmpobjid = CreateObject(1723, 143.151672, 1696.023803, -1.860599, 0.000000, 0.000000, 270.000000, 300.00); 
tmpobjid = CreateObject(1723, 143.189926, 1692.075805, -1.860599, 0.000000, 0.000000, 270.000000, 300.00); 
tmpobjid = CreateObject(1723, 140.126983, 1688.998535, -1.860599, 0.000000, 0.000000, -900.000000, 300.00); 
tmpobjid = CreateObject(1723, 138.298141, 1696.168334, -1.860599, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1827, 139.923049, 1692.763549, -1.859990, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1827, 137.644210, 1692.686889, -1.859990, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1724, 135.069839, 1694.389282, -1.858700, 0.000000, 0.000000, 62.000000, 300.00); 
tmpobjid = CreateObject(1724, 135.455291, 1690.635742, -1.858700, 0.000000, 0.000000, 125.000000, 300.00); 
tmpobjid = CreateObject(1714, 119.799461, 1693.650268, -1.858700, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(1714, 119.570678, 1698.346435, -1.858700, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(1714, 119.449653, 1704.299316, -1.858700, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.137489, 1705.139282, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.129837, 1702.879150, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.098907, 1699.173828, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.161346, 1696.814331, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.315612, 1693.693603, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2164, 115.331901, 1691.520629, -1.857499, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2195, 143.066680, 1697.117309, -1.258999, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2195, 141.732452, 1688.920288, -1.258999, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(2195, 136.309387, 1688.885375, -1.258999, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19526, 146.870605, 1706.787109, -1.858989, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19526, 149.239212, 1706.759155, -1.858989, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19526, 151.924850, 1706.780029, -1.858989, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19526, 152.454254, 1698.442504, -1.858999, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(19526, 150.033691, 1698.398803, -1.858999, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(19526, 147.247451, 1698.379760, -1.858999, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(2165, 129.856430, 1711.446166, -1.857900, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(1714, 129.254592, 1712.663085, -1.856400, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1724, 126.339630, 1708.333618, -1.858700, 0.000000, 0.000000, 135.000000, 300.00); 
tmpobjid = CreateObject(1724, 133.059097, 1709.298828, -1.858700, 0.000000, 0.000000, -135.000000, 300.00); 
tmpobjid = CreateObject(2164, 125.082763, 1712.741577, -1.857300, 0.000000, 0.000000, 40.000000, 300.00); 
tmpobjid = CreateObject(2165, 139.706237, 1711.452392, -1.857900, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(1714, 139.087661, 1712.999389, -1.856400, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1724, 136.328994, 1708.458984, -1.858700, 0.000000, 0.000000, 135.000000, 300.00); 
tmpobjid = CreateObject(1724, 142.875122, 1709.008544, -1.858700, 0.000000, 0.000000, -135.000000, 300.00); 
tmpobjid = CreateObject(2164, 142.737213, 1713.164184, -1.857300, 0.000000, 0.000000, -40.000000, 300.00); 
tmpobjid = CreateObject(948, 135.214797, 1712.540649, -1.919600, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(948, 142.784240, 1710.745971, -1.919600, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(948, 132.079605, 1712.190551, -1.919600, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19175, 129.422897, 1713.479492, 0.402099, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(19173, 138.851394, 1713.372558, 0.365700, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1775, 131.100051, 1688.861572, -0.778999, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(2002, 129.552398, 1688.923706, -1.859899, 0.000000, 0.000000, 180.000000, 300.00); 
tmpobjid = CreateObject(2002, 125.258499, 1710.589233, -1.858000, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(2002, 134.880538, 1711.091430, -1.858000, 0.000000, 0.000000, 90.000000, 300.00); 
tmpobjid = CreateObject(1491, 119.064567, 1688.384887, -1.907289, 0.000000, 0.000000, 0.000000, 300.00); 
tmpobjid = CreateObject(1232, 150.342697, 1702.385009, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 136.436325, 1695.920532, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 136.190200, 1703.598510, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 129.944778, 1698.507812, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 117.728370, 1694.260498, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 117.684036, 1701.098510, 3.962300, 180.000000, 0.000000, -4.000000, 300.00); 
tmpobjid = CreateObject(1232, 139.345367, 1711.188964, 3.962300, 180.000000, 0.000000, -4.000000, 300.00);


//////////////////////////////////////OSIGURANJE/////////////////////////////////////////////////////
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2026-09-21 21:21:55" by "Rile"
	Created by "Rile"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObject(18766, 1304.476318, -1867.270874, 14.502599, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1299.971069, -1872.755126, 14.502599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1292.656860, -1872.736572, 14.502599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1287.944702, -1867.249389, 14.502599, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1301.500244, -1867.294189, 12.062600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "tiles7-128x128", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1296.598632, -1867.298583, 12.062600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "tiles7-128x128", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1291.675048, -1867.283813, 12.062600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "tiles7-128x128", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1289.592773, -1867.261108, 12.062600, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "tiles7-128x128", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1302.478027, -1867.268554, 16.502599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19129, "dancefloors", "plastic5-small", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1297.664306, -1867.255615, 16.502599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19129, "dancefloors", "plastic5-small", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1292.848510, -1867.232421, 16.502599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19129, "dancefloors", "plastic5-small", 0x00000000);
tmpobjid = CreateDynamicObject(18766, 1289.867065, -1867.231689, 16.502599, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19129, "dancefloors", "plastic5-small", 0x00000000);
tmpobjid = CreateDynamicObject(19454, 1301.629028, -1862.361450, 14.277400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "policeshieldgls", 0x00000000);
tmpobjid = CreateDynamicObject(19454, 1290.517211, -1862.368774, 14.277400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "policeshieldgls", 0x00000000);
tmpobjid = CreateDynamicObject(19391, 1296.114135, -1862.360595, 14.269200, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey", 0x00000000);
tmpobjid = CreateDynamicObject(19455, 1295.836914, -1864.021850, 19.558099, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 6922, "vgnretail6", "vgsn_chplroof", 0x00000000);
tmpobjid = CreateDynamicObject(7914, 1295.898315, -1864.365966, 19.637411, 0.000000, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterialText(tmpobjid, 0, "ZIVOTNO OSIGURANJE", 110, "Calibri", 20, 0, 0xFFFFFFFF, 0x00000000, 1);
tmpobjid = CreateDynamicObject(18762, 1300.779296, -1864.119140, 19.457300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 6922, "vgnretail6", "vgsn_chplroof", 0x00000000);
tmpobjid = CreateDynamicObject(18762, 1290.495239, -1864.044799, 19.457300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 6922, "vgnretail6", "vgsn_chplroof", 0x00000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObject(2165, 1296.862915, -1868.758422, 12.538900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(1723, 1303.284790, -1865.509887, 12.499099, 0.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(2314, 1301.191040, -1866.943847, 12.559700, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(1724, 1301.427001, -1869.091308, 12.559200, 0.000000, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(644, 1302.346435, -1870.830810, 12.857299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(644, 1290.181396, -1870.371215, 12.857299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(2165, 1292.897705, -1868.846557, 12.538900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(2356, 1297.495483, -1870.315673, 12.560649, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(2356, 1293.013671, -1870.267944, 12.560649, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
tmpobjid = CreateDynamicObject(1491, 1295.332763, -1862.335571, 12.557760, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 


//////////////////////////////////////SPAWN 2.0/////////////////////////////////////////////////////
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2026-09-21 20:27:54" by "Rile"
	Created by "Rile"
*/
//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(18766, 1760.677612, -2182.508544, 12.092758, 90.099990, -179.500076, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.226318, -2198.564697, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.218383, -2196.260009, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.237670, -2193.755615, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.257812, -2191.337158, 12.315699, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.124145, -2191.309326, 12.315699, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.162841, -2193.771240, 12.315699, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.157470, -2196.378417, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.185546, -2198.562500, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.338134, -2170.086425, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0xFF00FFFF);
tmpobjid = CreateDynamicObjectEx(19439, 1763.423339, -2170.144775, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.437988, -2167.868652, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.438598, -2165.470703, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1763.449829, -2163.051513, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.447875, -2167.797119, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.501342, -2165.433349, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1758.590820, -2163.044921, 12.295700, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1471.614257, -2156.761474, 12.107663, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1471.682495, -2166.582519, 12.090528, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1471.750854, -2176.483154, 12.073248, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1471.775878, -2179.894287, 12.067303, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1465.975952, -2146.898193, 12.124876, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1466.054199, -2156.841308, 12.107526, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1471.546386, -2146.861083, 12.124937, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1466.122436, -2166.743896, 12.090254, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1466.190917, -2176.634277, 12.072992, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1466.215576, -2180.034423, 12.067061, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1467.942260, -2179.566162, 12.067885, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1467.875610, -2169.916259, 12.084727, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1467.808715, -2160.186767, 12.101707, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1467.741210, -2150.406982, 12.118770, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1467.715698, -2146.895507, 12.124888, 90.099990, 90.400024, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.823974, -2181.117675, 11.771098, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.798706, -2175.788330, 11.781098, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.770996, -2170.463623, 11.791098, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.794433, -2165.055419, 11.811099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.788818, -2159.129882, 11.811099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.753784, -2153.363037, 11.831099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.724975, -2148.517822, 11.831099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1468.700439, -2143.749755, 11.831099, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1463.360351, -2193.812744, 12.381099, 0.000000, 93.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1463.357543, -2191.308105, 12.381099, 0.000000, 93.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1463.321899, -2196.434814, 12.381099, 0.000000, 93.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1463.327880, -2198.734863, 12.381099, 0.000000, 93.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1486.339355, -2198.517822, 12.301099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1486.366699, -2196.195068, 12.301099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1486.314819, -2193.485107, 12.301099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1486.332031, -2190.979492, 12.301099, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18766, 1760.646362, -2178.928466, 12.099005, 90.099990, -179.500076, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1760.784057, -2182.643554, 11.799808, -89.300041, 90.000000, 89.299980, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, 1760.833374, -2178.603271, 11.799808, -89.900032, 90.000000, 89.299980, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19425, 1757.450073, -2184.803466, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1760.670043, -2184.803466, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 1755.838134, -2182.607666, 13.160400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 1755.833007, -2178.421630, 13.160400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 1765.472167, -2178.539062, 13.160400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 1765.464721, -2182.702636, 13.160400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1765.373291, -2176.267089, 15.164999, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1765.366333, -2184.964599, 15.164999, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1755.705810, -2184.874511, 15.164999, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1755.692871, -2176.178222, 15.164999, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1465.744995, -2184.804931, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1468.959960, -2184.792968, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1472.119506, -2184.803466, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1465.502685, -2141.698486, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1468.801025, -2141.680419, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1471.989257, -2141.675537, 12.606439, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 1473.849853, -2141.931396, 13.368700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 1463.439575, -2141.855468, 13.368700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 1463.658691, -2184.864990, 13.368700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 1474.059326, -2184.718994, 13.368700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1474.117187, -2185.330566, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1463.760742, -2185.609375, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1473.811401, -2176.334472, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1473.708862, -2165.436035, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1473.734252, -2154.487548, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1473.851562, -2141.139648, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1463.445556, -2141.098632, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1463.851318, -2154.407226, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1463.830566, -2165.540283, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 1463.815185, -2176.069824, 15.147399, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1462.351196, -2152.073486, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1462.353637, -2171.641113, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1462.433471, -2175.024658, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1474.709838, -2151.664062, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1474.719116, -2171.250732, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 1474.699462, -2175.116210, 14.858400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19439, 1459.250244, -2197.869140, 12.381099, 0.000000, 93.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3464, 1489.384521, -2170.365966, 14.810600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(7940, 1518.410156, -2172.367431, 15.671299, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3466, 1547.252807, -2169.794189, 15.095999, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3464, 1573.790405, -2170.376708, 14.810600, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3444, 1600.619750, -2170.013671, 15.058400, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(7940, 1629.440063, -2172.478271, 15.671299, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1764.109863, -2184.803466, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1763.860351, -2176.433593, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1760.570068, -2176.433593, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(19425, 1757.289550, -2176.433593, 12.556427, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 

/////////////////////////////////PUMPA KOD BURGA/////////////////////////////////////////////////
CreateObject(1676, 998.36963, -937.82037, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(1676, 1000.58051, -937.57959, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(1676, 1002.67590, -937.25037, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(1676, 1005.28644, -936.85699, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(1676, 1007.30701, -936.55908, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(1676, 1009.54547, -936.21936, 42.86110,   0.00000, 0.00000, 9.00000);
CreateObject(970, 998.88092, -949.16248, 41.68860,   0.00000, 0.00000, 8.00000);
CreateObject(970, 1002.97675, -948.59247, 41.68860,   0.00000, 0.00000, 8.00000);
CreateObject(970, 1007.06793, -948.00354, 41.68860,   0.00000, 0.00000, 8.00000);
CreateObject(970, 1009.11310, -947.74500, 41.68860,   0.00000, 0.00000, 8.00000);
CreateObject(11417, 1005.91351, -950.67603, 46.11920,   0.00000, 0.00000, -54.00000);
CreateObject(3928, 1003.17468, -936.85858, 47.20550,   0.00000, 0.00000, 7.00000);
CreateObject(1676, 1001.84747, -929.96710, 48.72470,   0.00000, 0.00000, 10.00000);

/////////////////////////////PUMPA BLIZU AUTO SKOLE /////////////////////////////////////////////
CreateObject(3928, 1942.29041, -1771.60901, 18.53710,   0.00000, 0.00000, 0.00000);
CreateObject(1676, 1942.02698, -1779.87952, 20.07450,   0.00000, 0.00000, 0.00000);
CreateObject(970, 1951.74280, -1775.14331, 13.16310,   0.00000, 0.00000, 90.00000);
CreateObject(970, 1951.70093, -1769.88245, 13.16310,   0.00000, 0.00000, 90.00000);
CreateObject(970, 1951.71826, -1764.66113, 13.16310,   0.00000, 0.00000, 90.00000);

///////////////////////////////////AUTO SKOLA//////////////////////////////////////////////
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2026-09-21 19:16:19" by "Rile"
	Created by "Rile"
*/

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(18980, 2048.482421, -1921.872680, 3.443900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.290771, -1921.235595, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.274291, -1918.062377, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.277587, -1914.862548, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.283691, -1911.690429, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18980, 2048.495849, -1910.675292, 3.463900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.300781, -1908.527587, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.305297, -1905.336547, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18980, 2048.548339, -1905.451293, 3.463900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.316650, -1902.138916, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2047.327270, -1898.932373, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2050.774658, -1898.946777, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2054.268554, -1898.945922, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2057.734375, -1898.952026, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2061.235351, -1898.952026, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2064.714355, -1898.962280, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2068.196289, -1898.980102, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19355, 2069.954589, -1898.980590, 15.894399, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "bluedirt1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(18980, 2071.044921, -1900.000366, 3.463900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "sjmlahus26", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19455, 2044.817749, -1896.636108, 20.655010, 0.000000, 0.000000, -46.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18880, "speedcamera1", "metallamppost4", 0x00000000);
tmpobjid = CreateDynamicObjectEx(7914, 2044.388305, -1896.590454, 21.022285, 0.000000, 0.000000, 44.100006, 300.00, 300.00); 
SetDynamicObjectMaterialText(tmpobjid, 0, "Auto Skola ", 70, "Calibri", 20, 0, 0xFFFFFFFF, 0x00000000, 1);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(970, 2061.302978, -1922.371704, 13.122300, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2065.452636, -1922.381225, 13.122300, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2069.568847, -1922.341430, 13.122300, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2071.702148, -1920.273437, 13.122300, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2071.723388, -1916.115234, 13.122300, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2071.629394, -1903.469116, 13.122300, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2071.636230, -1899.301879, 13.122300, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2047.279296, -1922.355224, 13.122300, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(970, 2051.451660, -1922.381591, 13.122300, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(3660, 2059.620117, -1899.009277, 14.743700, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1360, 2046.481445, -1910.758789, 13.324899, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1360, 2046.476928, -1905.271362, 13.324899, 0.000000, 0.000000, 90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 2053.402587, -1923.070068, 13.284899, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 2059.245605, -1922.995605, 13.284899, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 2072.433837, -1914.075317, 13.284899, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1361, 2072.239746, -1905.369995, 13.284899, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2071.674560, -1906.083862, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2071.658447, -1913.620483, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2059.010009, -1922.243774, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2053.712890, -1922.234375, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2049.449218, -1910.610351, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(1232, 2049.483886, -1905.364990, 15.167699, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 


////////////////////////////////////////// RIBOLOVAC MAPA
//Map Exported with Texture Studio By: [uL]Pottus////////////////////////////////////////////////////////////////
//////////////////////////////////////////////and Crayder////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2026-09-30 20:22:59" by "Rile"
	Created by "Rile"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(19428, 406.568298, -2087.599365, 7.196699, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 406.569244, -2084.137451, 7.216699, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 406.550476, -2080.691894, 7.216711, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 408.231140, -2079.029541, 7.216700, 90.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 408.246490, -2089.263183, 7.216700, 90.000000, 0.000000, 90.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 409.913085, -2087.580322, 7.216700, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 409.934570, -2084.125488, 7.216700, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 409.945648, -2080.662841, 7.216700, 90.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.254272, -2087.725830, 7.947598, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.239807, -2084.514892, 7.937597, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.243408, -2081.310546, 7.937596, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.222442, -2080.549316, 7.947597, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 407.633697, -2081.310546, 7.247593, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 407.383270, -2081.310546, 7.097591, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 406.992858, -2081.310546, 6.947585, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 406.716949, -2082.823242, 7.196699, 90.000000, -87.700004, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19428, 406.588348, -2079.602050, 7.216699, 90.000000, -87.700004, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 407.833892, -2081.310546, 7.467596, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.014007, -2081.310546, 7.677602, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, 408.154174, -2081.310546, 7.867604, 0.000000, 90.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19123, 406.900665, -2089.119873, 8.550094, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19123, 409.670562, -2089.119873, 8.550094, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19123, 406.670684, -2079.224609, 8.550094, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(11496, 418.839996, -2088.991699, 0.192900, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11496, 413.325805, -2078.526611, 0.192900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(8613, 414.069702, -2084.088378, 4.623998, 0.000000, 0.000000, 89.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11496, 434.842773, -2088.986816, 0.192900, 0.000000, 0.000000, -90.000000, 300.00, 300.00); 
tmpobjid = CreateDynamicObjectEx(11496, 413.317169, -2062.661865, 0.192900, 0.000000, 0.000000, 0.000000, 300.00, 300.00); 



    return 1;
}