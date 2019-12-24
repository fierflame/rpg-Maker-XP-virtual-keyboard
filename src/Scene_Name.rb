#==============================================================================
# ■ Scene_Name
#------------------------------------------------------------------------------
# 　处理名称输入画面的类。
#==============================================================================
class Scene_Name
  #--------------------------------------------------------------------------
  # ● 主处理
  #--------------------------------------------------------------------------
  def main
    # 获取角色
    @actor = $game_actors[$game_temp.name_actor_id]
    # 生成窗口
    @edit_window = Window_NameEdit.new(@actor, $game_temp.name_max_char)
    @input_window = PBZ_Keyboard.new
    # 执行过渡
    Graphics.transition
    # 主循环
    loop do
      # 刷新游戏画面
      Graphics.update
      # 刷新输入信息
      Input.update
      # 刷新信息
      update
      # 如果画面切换就中断循环
      if $scene != self
        break
      end
    end
    # 准备过渡
    Graphics.freeze
    # 释放窗口
    @edit_window.dispose
    @input_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面
  #--------------------------------------------------------------------------
  def update
    # 刷新窗口
    @edit_window.update
    char=@input_window.update

    case char
    when nil #空
    when 'back' #删除指令
      if @edit_window.index == 0# 光标位置为 0 的情况下
        $game_system.se_play($data_system.buzzer_se) # 演奏冻结 SE
      else
        $game_system.se_play($data_system.cancel_se) # 演奏取消 SE
        @edit_window.back# 删除文字
      end
    when 'ok' #确认指令
      if @edit_window.name == ""# 名称为空的情况下
        @edit_window.restore_default# 还原为默认名称
        if @edit_window.name == ""# 名称为空的情况下
          $game_system.se_play($data_system.buzzer_se)# 演奏冻结 SE
        else
          $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        end
      else
        @actor.name = @edit_window.name# 更改角色名称
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        $scene = Scene_Map.new# 切换到地图画面
      end
    else#正常输入
      if @edit_window.index==$game_temp.name_max_char#光标位置为最大的情况下
        $game_system.se_play($data_system.buzzer_se)# 演奏冻结 SE
      else
        $game_system.se_play($data_system.decision_se)# 演奏确定 SE
        @edit_window.add(char)# 添加文字
      end
    end
  end
end
