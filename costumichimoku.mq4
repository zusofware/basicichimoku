//+------------------------------------------------------------------+
//|                                               costumichimoku.mq4 |
//|                                          Copyright 2021, Sukino. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
//--- input parameters
input int      tenkan_sen=9;
input int      Kijun_sen=26;
input int      senkou_span_B=52;
input int      magic_number=300794;
input double   lots=0.1;
//=====================================================================
//======               Variable Global   ==============================
double nilaiTenkansen;
double nilaiKijunsen;
double nilaiSenkouspanA;
double nilaiSenkouspanB;
double nilaiSenkouspanA26;
double nilaiSenkouspanB26;
double nilaiChikuspan;
string tampilTenkansen;
string tampilKijunsen;
string tampilSenkouspanA;
string tampilSenkouspanB;
string tampilCikouspan;
bool posisiBuy = false;
bool posisiSell = false;
int numberTicket = 0;


//======               Fungsi Global    ================================
void tampilNilai()
{
   ObjectSetText("ObjTenkansen","Tenkansen: "+tampilTenkansen,7, "Verdana", Red);
   ObjectSetText("ObjKijunsen","Kijunsen: "+tampilKijunsen,7, "Verdana", Red);
   ObjectSetText("ObjSenkouspanA","SenkouspanA: "+tampilSenkouspanA,7, "Verdana", Red);
   ObjectSetText("ObjSenkouspanB","SenkouspanB: "+tampilSenkouspanB,7, "Verdana", Red);
   ObjectSetText("ObjCikouspan","Cikouspan: "+tampilCikouspan,7, "Verdana", Red);
}

void openBuy()
{
   if( nilaiSenkouspanA && nilaiSenkouspanB < nilaiKijunsen && nilaiTenkansen )
   {
      if( nilaiSenkouspanA26 && nilaiSenkouspanB26 < nilaiChikuspan )
      {
         if( nilaiSenkouspanA > nilaiSenkouspanB )
         {
            if( nilaiTenkansen > nilaiKijunsen )
            {
               if(!posisiBuy && !posisiSell)
               {
                  numberTicket = OrderSend(Symbol(),OP_BUY,lots,Ask,2,0,0);
                  
                  Alert("Buy");
                  posisiBuy = true;
                  
               }
            }
         }
      } 
   }
}

void openSell()
{
   if( nilaiSenkouspanA && nilaiSenkouspanB > nilaiKijunsen && nilaiTenkansen )
   {
      if( nilaiSenkouspanA26 && nilaiSenkouspanB26 > nilaiChikuspan )
      {
         if( nilaiSenkouspanA < nilaiSenkouspanB )
         {
            if( nilaiTenkansen < nilaiKijunsen )
            {
               if(!posisiSell && !posisiBuy)
               {
                  numberTicket = OrderSend(Symbol(),OP_SELL,lots,Bid,2,0,0);
                  
                  Alert("Sell");
                  posisiSell = true;
                  
               }
            }
         }
      } 
   }
}

void closeBuy()
{
   if(posisiBuy)
   {
      if( nilaiTenkansen < nilaiKijunsen )
      {
         
         if( OrderClose(numberTicket,lots,Bid,2,Red) )
         {
            posisiBuy = false;
            Alert("closeBuy");
         }
      }
   }
}

void closeSell()
{
   if(posisiSell)
   {
      if( nilaiTenkansen > nilaiKijunsen )
      {
         if( OrderClose(numberTicket,lots,Ask,2,Red) )
         {
            posisiSell = false;
            Alert("closeSell");
         }
      }
   }
}
//====================================================================

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      // object tenkansen
      ObjectCreate("ObjTenkansen", OBJ_LABEL, 0, 0, 0);
      ObjectSet("ObjTenkansen", OBJPROP_CORNER, 0);
      ObjectSet("ObjTenkansen", OBJPROP_XDISTANCE, 20);
      ObjectSet("ObjTenkansen", OBJPROP_YDISTANCE, 20);
      
      // object kijunsen
      ObjectCreate("ObjKijunsen", OBJ_LABEL, 0, 0, 0);
      ObjectSet("ObjKijunsen", OBJPROP_CORNER, 0);
      ObjectSet("ObjKijunsen", OBJPROP_XDISTANCE, 20);
      ObjectSet("ObjKijunsen", OBJPROP_YDISTANCE, 40);
      
      // object senkouspanA
      ObjectCreate("ObjSenkouspanA", OBJ_LABEL, 0, 0, 0);
      ObjectSet("ObjSenkouspanA", OBJPROP_CORNER, 0);
      ObjectSet("ObjSenkouspanA", OBJPROP_XDISTANCE, 20);
      ObjectSet("ObjSenkouspanA", OBJPROP_YDISTANCE, 60);
      
      // object senkouspanB
      ObjectCreate("ObjSenkouspanB", OBJ_LABEL, 0, 0, 0);
      ObjectSet("ObjSenkouspanB", OBJPROP_CORNER, 0);
      ObjectSet("ObjSenkouspanB", OBJPROP_XDISTANCE, 20);
      ObjectSet("ObjSenkouspanB", OBJPROP_YDISTANCE, 80);
      
      // object cikouspan
      ObjectCreate("ObjCikouspan", OBJ_LABEL, 0, 0, 0);
      ObjectSet("ObjCikouspan", OBJPROP_CORNER, 0);
      ObjectSet("ObjCikouspan", OBJPROP_XDISTANCE, 20);
      ObjectSet("ObjCikouspan", OBJPROP_YDISTANCE, 100);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      nilaiTenkansen = iIchimoku(NULL,0,9,26,52,MODE_TENKANSEN,1);
      nilaiKijunsen = iIchimoku(NULL,0,9,26,52,MODE_KIJUNSEN,1);
      nilaiSenkouspanA = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,1);
      nilaiSenkouspanB = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,1);
      nilaiChikuspan = iIchimoku(NULL,0,9,26,52,MODE_CHIKOUSPAN,Kijun_sen+1);
      nilaiSenkouspanA26 = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,Kijun_sen+1);
      nilaiSenkouspanB26 = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANB,Kijun_sen+1);
      
      tampilTenkansen = DoubleToStr(nilaiTenkansen, 3);
      tampilKijunsen = DoubleToStr(nilaiKijunsen, 3);
      tampilSenkouspanA = DoubleToStr(nilaiSenkouspanA, 3);
      tampilSenkouspanB = DoubleToStr(nilaiSenkouspanB, 3);
      tampilCikouspan = DoubleToStr(nilaiChikuspan, 3);
      
      tampilNilai();
      openBuy();
      openSell();
      closeBuy();
      closeSell();
  }
//+------------------------------------------------------------------+
