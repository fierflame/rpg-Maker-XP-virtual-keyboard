#==============================================================================
# Ｚ PBZ键盘
#------------------------------------------------------------------------------
# 　版本 1.0
#==============================================================================
#==============================================================================
# ■ PBZ_Keyboard
#------------------------------------------------------------------------------
# 　键盘。
#==============================================================================
class PBZ_Keyboard < Window_Base
  #--------------------------------------------------------------------------
  #输入键盘
  # 请使用.push 加入新键盘
  # 成员应为数组：
  #[键盘驱动号,键盘标志,键盘名,键盘说明,键盘列表,不同驱动需要格外的不同参数]
  #--------------------------------------------------------------------------
  #       格外参数列表
  #--------------------------------------------------------------------------
  # 键盘驱动号 | 格外参数
  #     0      | 键盘列表
  #     1      | 输入法类,键盘列表
  #            | 
  #--------------------------------------------------------------------------
  KB=[]
  KB.push [1,0,'全拼输入法','全拼输入法',PBZ_IM_quanpin,[
     "" , "" ,"Q" ,"W" ,"E" ,"R" ,"T" ,"Y" ,"U" ,"I" ,"O" ,"P" , "" , "" ,
     "" , "" , "" ,"A" ,"S" ,"D" ,"F" ,"G" ,"H" ,"J" ,"K" ,"L" , "" , "" ,
     "" , "" , "" , "" ,"Z" ,"X" ,"C" ,"V" ,"B" ,"N" ,"M" , "" , "" , "" ]]
  KB.push [0,0,'字母&数字','',[
    "A" ,"B" ,"C" ,"D" ,"E" ,"F" ,"G" ,"H" ,"I" ,"J" ,"K" ,"L" ,"M" ,"N" ,
     "" ,"O" ,"P" ,"Q" ,"R" ,"S" ,"T" ,"U" ,"V" ,"W" ,"X" ,"Y" ,"Z" , "" ,
    "a" ,"b" ,"c" ,"d" ,"e" ,"f" ,"g" ,"h" ,"i" ,"j" ,"k" ,"l" ,"m" ,"n" ,
     "" ,"o" ,"p" ,"q" ,"r" ,"s" ,"t" ,"u" ,"v" ,"w" ,"x" ,"y" ,"z" , "" ,
     "" , "" ,"0" ,"1" ,"2" ,"3" ,"4" ,"5" ,"6" ,"7" ,"8" ,"9" , "" , "" ]]
  KB.push [0,0,'符号','',[
    "/" ,"." ,"," ,"。","～","…",":" ,";" ,"@" ,"#" ,"$" ,"!" ,"?" ,"\\",
     "" , "" ,"+" ,"-" ,"×","÷","＝","%" , "" , "" ,"♀","♂", "" , "" ,
     "" ,"↖","↑","↗", "" ,"(" ,")" ,"[" ,"]" ,"{" ,"}" ,"<" ,">" , "" ,
     "" ,"←", "" ,"→", "" , "" , "" ,"△","▽","○","◇","□","☆", "" ,
     "" ,"↙","↓","↘", "" , "" , "" ,"▲","▼","●","◆","■","★", "" ]]
  KB.push [0,-1,'密码键盘','密码专用键盘',[
    "~" ,"!" ,"@" ,"#" ,"$" ,"%" ,"^" ,"&" ,"*" ,"(" ,")" ,"_" ,"+" ,"|" ,
    "`" ,"1" ,"2" ,"3" ,"4" ,"5" ,"6" ,"7" ,"8" ,"9" ,"0" ,"-" ,"=" ,"\\",
    "{" ,"Q" ,"W" ,"E" ,"R" ,"T" ,"Y" ,"U" ,"I" ,"O" ,"P" ,"[" ,"]" ,"}" ,
    ":" ,'"' ,"A" ,"S" ,"D" ,"F" ,"G" ,"H" ,"J" ,"K" ,"L" ,";" ,"'" , "" ,
    "<" ,">" ,"?" ,"Z" ,"X" ,"C" ,"V" ,"B" ,"N" ,"M" ,"," ,"." ,"/" ," " ]]
  #--------------------------------------------------------------------------
  # ● 定义其他常量
  #--------------------------------------------------------------------------
  DRIVER = 1                      #支持的最大键盘驱动号
  #--------------------------------------------------------------------------
  # ● 初始化对像
  #     type       :             键盘类型
  #--------------------------------------------------------------------------
  def initialize(type = 0)
    super(0, 128, 640, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @type = 0
    @x=0
    @y=0
    @KB=[]
    @pageCount=0
    @page=0
    @borderColor = system_color       #边框颜色
    @IM=nil
    if type < 0
      for i in 0...KB.size
        if (KB[i][0] <= DRIVER) && (KB[i][1] == type)
          @KB.push(KB[i])
        end
      end
    else
      for i in 0...KB.size
        if (KB[i][0] <= DRIVER) &&
           (KB[i][1] >= 0) && ((KB[i][1] & type) == type)
          @KB.push(KB[i])
        end
      end
    end
    if @KB.size == 0
      for i in 0...KB.size
        if (KB[i][1] >= 0) &&
           (KB[i][0] <= DRIVER)
          @KB.push(KB[i])
        end
      end
    end
    swicthType
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # ● 切换类型
  #--------------------------------------------------------------------------
  def swicthType
    self.contents.clear()
    self.contents.font.size=24
    self.contents.font.bold=false
    self.contents.font.italic=false
    case @KB[@type][0]
    when 0
      @IM = nil
      for i in 0...70
        if (char = @KB[@type][4][i]) != ''
          x=6+(i%14)*42
          y=32+(i/14)*42
          rect=Rect.new(x+1,y+1,40,40)
          self.contents.paint_rect(rect,2,@borderColor) 
          self.contents.draw_text(rect,char, 1)
        end
      end
    when 1
      @IM = @KB[@type][4].new
      for i in 0...42
        if (char = @KB[@type][5][i]) != ''
          x=6+(i%14)*42
          y=32+(i/14)*42+42*2
          rect=Rect.new(x+1,y+1,40,40)
          self.contents.paint_rect(rect,2,@borderColor) 
          self.contents.draw_text(rect,char, 1)
        end
      end
    end



    s2=@KB[@type][2]
    rect=Rect.new(6+42*5,32+210+3,168,36)
    self.contents.draw_text(rect,s2, 1)
    if @KB.size > 1
      rect=Rect.new(6,32+210+3,42,36)
      self.contents.paint_rect(rect,2,@borderColor) 
      self.contents.draw_text(rect,"<R", 1)
      rect=Rect.new(6+42*1,32+210+3,168,36)
      s1=@KB[((@type-1<0)?@KB.size-1:@type-1)][2]
      self.contents.paint_rect(rect,2,@borderColor) 
      self.contents.draw_text(rect,s1, 1)
      rect=Rect.new(6+42*9,32+210+3,168,36)
      s3=@KB[((@type+1<@KB.size)?@type+1:0)][2]
      self.contents.paint_rect(rect,2,@borderColor)
      self.contents.draw_text(rect,s3, 1)
      rect=Rect.new(6+42*13,32+210+3,42,36)
      self.contents.paint_rect(rect,2,@borderColor) 
      self.contents.draw_text(rect,"L>", 1)
    end
    #取消
    rect=Rect.new(6+42*10,32+252,84,36)
    self.contents.paint_rect(rect,2,@borderColor)
    self.contents.draw_text(rect,"删除", 1)
    #确认
    rect=Rect.new(6+42*12,32+252,84,36)
    self.contents.paint_rect(rect,2,@borderColor)
    self.contents.draw_text(rect,"确定", 1)
    #说明
    self.contents.font.size=16
    self.contents.draw_text(6,32+252,42*12,36,@KB[@type][3])
  end
  #--------------------------------------------------------------------------
  # ● 刷新光标矩形
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @y < 5
      self.cursor_rect.set(6+@x*42, 32+@y*42, 42, 42)
    elsif @y == 5
      if(@x<1)
        self.cursor_rect.set(6,32+210+3,42,36)
      elsif(@x<5)
        self.cursor_rect.set(6+42*1,32+210+3,168,36)
      elsif(@x<9)
        self.cursor_rect.set(6+42*5,32+210+3,168,36)
      elsif(@x<13)
        self.cursor_rect.set(6+42*9,32+210+3,168,36)
      else
        self.cursor_rect.set(6+42*13,32+210+3,42,36)
      end
    else
        if(@x<10)
      self.cursor_rect.set(6+42*0,32+210+42,42*10,36)
        elsif(@x<12)
      self.cursor_rect.set(6+42*10,32+210+42,84,36)
        else
      self.cursor_rect.set(6+42*12,32+210+42,84,36)
        end
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新键盘驱动1画面 
  #--------------------------------------------------------------------------
  def update_1 (input = false)
    self.contents.font.size=24
    self.contents.font.bold=false
    self.contents.font.italic=false
    
    self.contents.fill_rect(0,0,640,116,Color.new(0, 0, 0, 0))
    
    self.contents.draw_text(48,0,320,32,@IM.value)
    
    @char=[]
    @pageCount = (@IM.size+19) / 20
    if(@pageCount>0)
      if input
        @page = 0
      end
      str=(@page+1).to_s+"/"+@pageCount.to_s+"页"
      self.contents.draw_text(272,0,320,32,str,2)
      if @page>0
        rect=Rect.new(6,32,42,42)
        self.contents.paint_rect(rect,2,@borderColor)
        self.contents.draw_text(6,32,42,42,"<X", 1)
      end
      if @page+1 < @pageCount
        rect=Rect.new(552,32,42,42)
        self.contents.paint_rect(rect,2,@borderColor)
        self.contents.draw_text(552,32,42,42,"Y>", 1)
      end
      
      if(@IM.size > ( @page + 1) * 20 )
        @char = @IM[@page*20, 20]
      else
        @char = @IM[@page*20...@IM.size]
      end

      for i in 0...20
        char = @char[i]
        if char == nil
          break
        end
        x=6+(i%10)*42+84
        y=32+(i/10)*42
        rect=Rect.new(x+1,y+1,40,40)
        self.contents.paint_rect(rect,2,@borderColor) 
        self.contents.draw_text(rect,char,1)
      end

    end
  end
  #--------------------------------------------------------------------------
  # ● 删除
  #--------------------------------------------------------------------------
  def back
    case @KB[@type][0]
    when 0
      return 'back'
    when 1
      if(@IM.back)
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        update_1
      else
        return 'back'
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # ● 输入法页面，上一页
  #--------------------------------------------------------------------------
  def prevPage
    case @KB[@type][0]
    when 0
    when 1
      if @page>0
        @page-=1
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        update_1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 输入法页面，下一页 
  #--------------------------------------------------------------------------
   def nextPage
    case @KB[@type][0]
    when 0
    when 1
      if @page + 1 <@pageCount
        @page+=1
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        update_1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 上一键盘
  #--------------------------------------------------------------------------
  def prevKB
    if @KB.size > 0
      @type=((@type>0)?(@type-1):(@KB.size-1))
      swicthType
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    end
  end
  #--------------------------------------------------------------------------
  # ● 下一键盘
  #--------------------------------------------------------------------------
   def nextKB
    if @KB.size > 0
      @type=((@type<@KB.size-1)?(@type+1):0)
      swicthType
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面
  #--------------------------------------------------------------------------
  def update
    super
    if Input.repeat?(Input::RIGHT)
      if @y == 6
        if(@x<10)
          @x=10
        elsif(@x<12)
          @x=12
        else
          @x=4
        end
      elsif @y == 5
        if(@x<1)
          @x=2
        elsif(@x<5)
          @x=6
        elsif(@x<9)
          @x=10
        elsif(@x<13)
          @x=13
        else
          @x=0
        end
      else
        @x=((@x<13)?(@x+1):0)
      end
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    elsif Input.repeat?(Input::LEFT)
      if @y == 6
        if(@x > 11)
          @x=10
        elsif(@x > 9)
          @x=4
        else
          @x=12
        end
      elsif @y == 5
        if(@x>12)
          @x=10
        elsif(@x>8)
          @x=6
        elsif(@x>4)
          @x=2
        elsif(@x>0)
          @x=0
        else
          @x=13
        end
      else
        @x=((@x>0)?(@x-1):13)
      end
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    elsif Input.repeat?(Input::DOWN)
      @y=((@y<6)?(@y+1):0)
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    elsif Input.repeat?(Input::UP)
      @y=((@y>0)?(@y-1):6)
      $game_system.se_play($data_system.decision_se)# 演奏确定 SE
    elsif Input.repeat?(Input::A)
      if(@y<5)
        case @KB[@type][0]
        when 0
          char=@KB[@type][4][@y*14+@x]
          if(char!='')
            return char
          end
        when 1
          if @y<2
            if 1<@x && @x<12
              char=@char[@x-2 + @y*10]
              if(char!=nil)
                @IM.init
                update_1 (true)
                return char
              end
            elsif @y==0 && @x==0
              prevPage
            elsif @y==0 && @x==13
              nextPage
            end
          else
            char=@KB[@type][5][(@y-2)*14+@x]
            if(char=='')
            elsif (@IM.add(char))
              $game_system.se_play($data_system.decision_se)# 演奏确定 SE
              update_1 (true)
            else
               $game_system.se_play($data_system.buzzer_se)# 演奏冻结 SE
            end
          end
        end
      elsif @y == 5
        if(@x<=4)
          prevKB
        elsif(@x>=9)
          nextKB
        end
      elsif @y == 6
        if(@x<10)
        elsif(@x<12)
          return back
        else
          return 'ok'
        end
      end
    elsif Input.repeat?(Input::B)
      return back
    elsif Input.repeat?(Input::C)
      if(@y!=6 || @x < 12)
        @y=6
        @x=12
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
      else
        return 'ok'
      end
    elsif Input.repeat?(Input::X)
      prevPage
    elsif Input.repeat?(Input::Y)
      nextPage
    elsif Input.repeat?(Input::L)
      prevKB
    elsif Input.repeat?(Input::R)
      nextKB
    end
    update_cursor_rect
    return nil
  end
end
