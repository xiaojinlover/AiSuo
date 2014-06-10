package logic
{
	import flash.filters.DropShadowFilter;
	
	import mx.charts.AreaChart;
	import mx.charts.ColumnChart;
	import mx.charts.LineChart;
	import mx.charts.effects.SeriesInterpolate;
	import mx.charts.series.AreaSeries;
	import mx.charts.series.ColumnSeries;
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.graphics.Stroke;
	
	import util.HashMap;

	public class DataManager
	{
		private static var _singleton:Boolean=true;
		private static var _instance:DataManager;
		
		private var _timeArr:Array=["00:00","00:10","00:20","00:30","00:40","00:50","01:00","01:10","01:20","01:30","01:40","01:50",
															"02:00","02:10","02:20","02:30","02:40","02:50","03:00","03:10","03:20","03:30","03:40","03:50",
															"04:00","04:10","04:20","04:30","04:40","04:50","05:00","05:10","05:20","05:30","05:40","05:50",
															"06:00","06:10","06:20","06:30","06:40","06:50","07:00","07:10","07:20","07:30","07:40","07:50",
															"08:00","08:10","08:20","08:30","08:40","08:50","09:00","09:10","09:20","09:30","09:40","09:50",
															"10:00","10:10","10:20","10:30","10:40","10:50","11:00","11:10","11:20","11:30","11:40","11:50",
															"12:00","12:10","12:20","12:30","12:40","12:50","13:00","13:10","13:20","13:30","13:40","13:50",
															"14:00","14:10","14:20","14:30","14:40","14:50","15:00","15:10","15:20","15:30","15:40","15:50",
															"16:00","16:10","16:20","16:30","16:40","16:50","17:00","17:10","17:20","17:30","17:40","17:50",
															"18:00","18:10","18:20","18:30","18:40","18:50","19:00","19:10","19:20","19:30","19:40","19:50",
															"20:00","20:10","20:20","20:30","20:40","20:50","21:00","21:10","21:20","21:30","21:40","21:50",
															"22:00","22:10","22:20","22:30","22:40","22:50","23:00","23:10","23:20","23:30","23:40","23:50"];
		private var _dateArr:Array=["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15",
															"16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
		private var _monthArr:Array=["01","02","03","04","05","06","07","08","09","10","11","12"];
		private var _yearsArr:Array=["2011","2012"];
		private var _bulletArr:Array=["round","square","triangleDown","bubble","triangleUp"];
		
		private var _serEff:SeriesInterpolate;
		
		public var CustomLineChart:LineChart;
		public var CustomAreaChart:AreaChart;
		public var CustomColumnChart:ColumnChart;
		public var OVDayChart:AreaChart;
		public var OVMonthChart:ColumnChart;
		public var OVYearChart:ColumnChart;
		public var OVTotalChart:ColumnChart;
		
		public function DataManager()
		{
			if(_singleton){
				throw Error("请通过getInstance方法获取实例");
			}
			else{
				_serEff=new SeriesInterpolate();
				_serEff.duration=1000;
			}
		}
		
		public static function getInstance():DataManager{
			if(!_instance){
				_singleton=false;
				_instance=new DataManager();
				_singleton=true;
			}
			return _instance;
		}
		
		/**
		 *当日数据 
		 * 
		 */		
		public function InitDailyData(ResultData:XML):void{
			CustomLineChart.series=[];
			CustomLineChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _len:int=ResultData.children().length();
			
			for(var i:int=0;i<144;i++){
				var _xvalue:String=_timeArr[i].toString();
				
				var _obj:Object = new Object();
				_obj['xf']=_xvalue;
				
				for(var j:int=0;j<_len;j++){
					var _item:XML=XML(ResultData.children()[j]);
					_obj[_item.@Channel]="0";
					
					if(_item.data.(@time==_xvalue).toXMLString()!=""){
						try
						{
							_obj[_item.@Channel]=XML(_item.data.(@time==_xvalue)[0]).@value;
						} 
						catch(err:Error) 
						{
							_obj[_item.@Channel]="0";
						}
						
					}
				}
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			for(var k:int=0;k<_len;k++){
				var _itemxml:XML=XML(ResultData.children()[k]);
				var _itemTitle:String=_itemxml.@Channel;
				var _itemColor:String=_itemxml.@color;
				var _color:uint=uint("0x"+_itemColor.substr(1,_itemColor.length-1));
				
				var _line:LineSeries=new LineSeries();
				_line.displayName=_itemTitle;
				_line.xField="xf";
				_line.yField=_itemTitle;
				_line.setStyle("lineStroke",new Stroke(_color,2));
				_line.setStyle("showDataEffect",_serEff);
				//_line.setStyle("form","curve");
				_seriesArr.push(_line);
			}
			
			CustomLineChart.dataProvider=_dp;
			CustomLineChart.series=_seriesArr;
			CustomLineChart.seriesFilters=[];
		}
		
		/**
		 * 最近一周数据
		 * 
		 */		
		public function InitWeeklyData(ResultData:XML):void{
			CustomLineChart.series=[];
			CustomLineChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _itemLen:int=ResultData.children().length();
			var _dataLen:int=XML(ResultData.children()[0]).children().length();
			
			var _datefm:DateFormatter=new DateFormatter();
			_datefm.formatString="YYYY/MM/DD HH:NN";
			
			for(var i:int=0;i<_dataLen;i++){
				var _dataItem:XML=XML(ResultData.children()[0]).children()[i];
				var _dateStr:String=_dataItem.@day.toXMLString();
				var _timeStr:String=_dataItem.@time.toXMLString();

				var _hh:int=int(_timeStr.substr(0,2));
				var _mm:int=0;
				if(_hh==24){
					_hh=23;
					_mm=59;
				}
				
				var _xvalue:Date=new Date(int(_dateStr.substr(0,4)),int(_dateStr.substr(5,2))-1,int(_dateStr.substr(8,2)),_hh,_mm,0,0);

				var _obj:Object = new Object();
				_obj['xf']=_datefm.format(_xvalue);
				
				for(var j:int=0;j<_itemLen;j++){
					var _item:XML=XML(ResultData.children()[j]);
					_obj[_item.@Channel]=XML(_item.children()[i]).@value.toXMLString();
				}
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			for(var k:int=0;k<_itemLen;k++){
				var _itemxml:XML=XML(ResultData.children()[k]);
				var _itemTitle:String=_itemxml.@Channel;
				var _itemColor:String=_itemxml.@color;
				var _color:uint=uint("0x"+_itemColor.substr(1,_itemColor.length-1));
				
				var _line:LineSeries=new LineSeries();
				_line.displayName=_itemTitle;
				_line.xField="xf";
				_line.yField=_itemTitle;
				_line.setStyle("lineStroke",new Stroke(_color,2));
				_line.setStyle("showDataEffect",_serEff);
				//_line.setStyle("form","curve");
				_seriesArr.push(_line);
			}
			
			CustomLineChart.dataProvider=_dp;
			CustomLineChart.series=_seriesArr;
			CustomLineChart.seriesFilters=[];
		}
		
		/**
		 * 月度数据
		 * 
		 */		
		public function InitMonthlyData(ResultData:XML):void{
			CustomColumnChart.series=[];
			CustomColumnChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _itemLen:int=ResultData.children().length();
			var _dataLen:int=XML(ResultData.children()[0]).children().length();
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			for(var i:int=0;i<_dataLen;i++){
				var _dataItem:XML=XML(ResultData.children()[0]).children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@day.toXMLString();
				
				for(var j:int=0;j<_itemLen;j++){
					var _item:XML=XML(ResultData.children()[j]);
					_obj[_item.@Channel]=XML(_item.children()[i]).@value.toXMLString();
				}
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			for(var k:int=0;k<_itemLen;k++){
				var _itemxml:XML=XML(ResultData.children()[k]);
				var _itemTitle:String=_itemxml.@Channel;
				
				var _colSeries:ColumnSeries=new ColumnSeries();
				_colSeries.xField="xf";
				_colSeries.yField=_itemTitle;
				_colSeries.displayName=_itemTitle;
				
				//_colSeries.setStyle("labelPosition","outside");
				_colSeries.setStyle("showDataEffect",_serEff);
				
				_seriesArr.push(_colSeries);
			}
			
			CustomColumnChart.series=_seriesArr;
			CustomColumnChart.dataProvider=_dp;
			//MonthlyChart.seriesFilters=[_filter];
		}
		
		/**
		 * 年度数据
		 * 
		 */		
		public function InitYearlyData(ResultData:XML):void{
			CustomColumnChart.series=[];
			CustomColumnChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _itemLen:int=ResultData.children().length();
			var _dataLen:int=XML(ResultData.children()[0]).children().length();
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			for(var i:int=0;i<_dataLen;i++){
				var _dataItem:XML=XML(ResultData.children()[0]).children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@month.toXMLString();
				
				for(var j:int=0;j<_itemLen;j++){
					var _item:XML=XML(ResultData.children()[j]);
					_obj[_item.@Channel]=XML(_item.children()[i]).@value.toXMLString();
				}
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			
			for(var k:int=0;k<_itemLen;k++){
				var _itemxml:XML=XML(ResultData.children()[k]);
				var _itemTitle:String=_itemxml.@Channel;
				
				var _colSeries:ColumnSeries=new ColumnSeries();
				_colSeries.xField="xf";
				_colSeries.yField=_itemTitle;
				_colSeries.displayName=_itemTitle;
				
				//_colSeries.setStyle("labelPosition","outside");
				_colSeries.setStyle("showDataEffect",_serEff);
				
				_seriesArr.push(_colSeries);
			}
			
			CustomColumnChart.series=_seriesArr;
			CustomColumnChart.dataProvider=_dp;
			//YearlyChart.seriesFilters=[_filter];
			
		}
		
		/**
		 * 所有年份数据
		 * 
		 */		
		public function InitAllYearsData(ResultData:XML):void{
			CustomColumnChart.series=[];
			CustomColumnChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _itemLen:int=ResultData.children().length();
			var _dataLen:int=XML(ResultData.children()[0]).children().length();
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			for(var i:int=0;i<_dataLen;i++){
				var _dataItem:XML=XML(ResultData.children()[0]).children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@month.toXMLString();
				
				for(var j:int=0;j<_itemLen;j++){
					var _item:XML=XML(ResultData.children()[j]);
					_obj[_item.@Channel]=XML(_item.children()[i]).@value.toXMLString();
				}
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			
			for(var k:int=0;k<_itemLen;k++){
				var _itemxml:XML=XML(ResultData.children()[k]);
				var _itemTitle:String=_itemxml.@Channel;
				
				var _colSeries:ColumnSeries=new ColumnSeries();
				_colSeries.xField="xf";
				_colSeries.yField=_itemTitle;
				_colSeries.displayName=_itemTitle;
				
				//_colSeries.setStyle("labelPosition","outside");
				_colSeries.setStyle("showDataEffect",_serEff);
				
				_seriesArr.push(_colSeries);
			}
			
			CustomColumnChart.series=_seriesArr;
			CustomColumnChart.dataProvider=_dp;
			//AllYearsChart.seriesFilters=[_filter];
			
		}
		
		/**
		 * 7天数据
		 * 
		 */		
		public function InitSevenDayData(ResultData:XML):void{
			CustomLineChart.series=[];
			CustomLineChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _item:XML=XML(ResultData.children()[0]);
			var _itemTitle:String=_item.@Channel;
			var _itemColor:String=_item.@color;
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			for(var i:int=0;i<7;i++){
				
				var _dataItem:XML=_item.children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@day.toXMLString();
				_obj[_itemTitle]=_dataItem.@value.toXMLString();
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			
			var _color:uint=uint("0x"+_itemColor.substr(1,_itemColor.length-1));
			
			var _line:LineSeries=new LineSeries();
			_line.displayName=_itemTitle;
			_line.xField="xf";
			_line.yField=_itemTitle;
			_line.setStyle("lineStroke",new Stroke(_color,2));
			_line.setStyle("showDataEffect",_serEff);
			//_line.setStyle("form","curve");
			_seriesArr.push(_line);
			
			CustomLineChart.dataProvider=_dp;
			CustomLineChart.series=_seriesArr;
			CustomLineChart.seriesFilters=[_filter];
		}
		
		/**
		 * 12月数据
		 * 
		 */		
		public function InitTwelveMonthData(ResultData:XML):void{
			CustomLineChart.series=[];
			CustomLineChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _item:XML=XML(ResultData.children()[0]);
			var _itemTitle:String=_item.@Channel;
			var _itemColor:String=_item.@color;
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			for(var i:int=0;i<12;i++){
				
				var _dataItem:XML=_item.children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@month.toXMLString();
				_obj[_itemTitle]=_dataItem.@value.toXMLString();
				
				_dp.addItem(_obj);
			}
			
			
			var _seriesArr:Array=[];
			
			var _color:uint=uint("0x"+_itemColor.substr(1,_itemColor.length-1));
			
			var _line:LineSeries=new LineSeries();
			_line.displayName=_itemTitle;
			_line.xField="xf";
			_line.yField=_itemTitle;
			_line.setStyle("lineStroke",new Stroke(_color,2));
			_line.setStyle("showDataEffect",_serEff);
			//_line.setStyle("form","curve");
			_seriesArr.push(_line);
			
			CustomLineChart.dataProvider=_dp;
			CustomLineChart.series=_seriesArr;
			CustomLineChart.seriesFilters=[_filter];
		}
		
		/**
		 * 每年数据
		 * 
		 */		
		public function InitEveryYearData(ResultData:XML):void{
			CustomColumnChart.series=[];
			CustomColumnChart.dataProvider=null;
			
			var _dp:ArrayCollection=new ArrayCollection();
			var _item:XML=XML(ResultData.children()[0]);
			var _itemTitle:String=_item.@Channel;
			var _datalen:int=_item.children().length();
			
			var _filter:DropShadowFilter=new DropShadowFilter(2,45,0xcccccc);
			
			var _noneobj:Object = new Object();
			_noneobj['xf']=int(XML(_item.children()[0]).@year.toXMLString())-1;
			_noneobj[_itemTitle]=0;
			_dp.addItem(_noneobj);
			
			for(var i:int=0;i<_datalen;i++){
				
				var _dataItem:XML=_item.children()[i];
				
				var _obj:Object = new Object();
				_obj['xf']=_dataItem.@year.toXMLString();
				_obj[_itemTitle]=_dataItem.@value.toXMLString();
				
				_dp.addItem(_obj);
			}
			
			var _seriesArr:Array=[];
			var _colSeries:ColumnSeries=new ColumnSeries();
			_colSeries.xField="xf";
			_colSeries.yField=_itemTitle;
			_colSeries.displayName=_itemTitle;
			
			//_colSeries.setStyle("labelPosition","outside");
			_colSeries.setStyle("showDataEffect",_serEff);
			
			_seriesArr.push(_colSeries);
			
			
			CustomColumnChart.dataProvider=_dp;
			CustomColumnChart.series=_seriesArr;
			CustomColumnChart.seriesFilters=[_filter];
		}
		
		//=============================OVData
		
		/**
		 *DailyChart初始化数据 
		 * 
		 */		
		public function InitOVDailyData(ResultData:XML):void{
			var _dp:ArrayCollection=new ArrayCollection();
			var _len:int=ResultData.children().length();
			
			for(var i:int=0;i<_len;i++){
				var _item:XML=XML(ResultData.children()[i]);
				var _xvalue:String=_item.@title.toXMLString();
				
				var _obj:Object = new Object();
				_obj['xf']=_xvalue;
				_obj['yf']=_item.@value.toXMLString();
				
				_dp.addItem(_obj);
			}
			
			OVDayChart.dataProvider=_dp;
		}
		
		/**
		 *MonthlyChart初始化数据 
		 * 
		 */		
		public function InitOVMonthlyData(ResultData:XML):void{
			var _dp:ArrayCollection=new ArrayCollection();
			var _len:int=ResultData.children().length();
			for(var i:int=0;i<_len;i++){
				var _item:XML=XML(ResultData.children()[i]);
				var _xvalue:String=_item.@title.toXMLString();
				
				var _obj:Object = new Object();
				_obj['xf']=_xvalue.substr(8,2);
				_obj['yf']=_item.@value.toXMLString();
				_dp.addItem(_obj);
			}
			OVMonthChart.dataProvider=_dp;
		}
		
		/**
		 *YearlyChart初始化数据 
		 * 
		 */		
		public function InitOVYearlyData(ResultData:XML):void{
			var _dp:ArrayCollection=new ArrayCollection();
			var _len:int=ResultData.children().length();
			for(var i:int=0;i<_len;i++){
				var _item:XML=XML(ResultData.children()[i]);
				var _xvalue:String=_item.@title.toXMLString();
				var _obj:Object = new Object();
				_obj['xf']=_xvalue.substr(5,2);
				_obj['yf']=_item.@value.toXMLString();
				
				_dp.addItem(_obj);
			}
			OVYearChart.dataProvider=_dp;
		}
		
		/**
		 *AllyearsChart初始化数据 
		 * 
		 */		
		public function InitOVAllyearsData(ResultData:XML):void{
			var _dp:ArrayCollection=new ArrayCollection();
			var _len:int=ResultData.children().length();
			for(var i:int=0;i<_len;i++){
				var _item:XML=XML(ResultData.children()[i]);
				var _xvalue:String=_item.@title.toXMLString();
				var _obj:Object = new Object();
				_obj['xf']=_xvalue;
				_obj['yf']=_item.@value.toXMLString();
				_dp.addItem(_obj);
			}
			OVTotalChart.dataProvider = _dp;
		}
	}
}