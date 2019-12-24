#版本 1.0
class Bitmap
  def paint_rect(a1,a2,a3,a4=nil,a5=nil,a6=nil)
    if a1.class == Rect
      x=a1.x
      y=a1.y
      width=a1.width
      height=a1.height
      size=a2
      color=a3
    else
      x=a1
      y=a2
      width=a3
      height=a4
      size=a5
      color=a6
    end
    fill_rect(x, y, width, size, color) 
    fill_rect(x, y, size, height, color) 
    fill_rect(x + width - size, y, size, height, color) 
    fill_rect(x, y + height - size, width, size, color) 
  end
end
