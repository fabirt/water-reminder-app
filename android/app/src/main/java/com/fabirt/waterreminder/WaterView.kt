package com.fabirt.waterreminder


import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View
import kotlin.math.sin

class WaterView @JvmOverloads constructor(
        context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private val paint = Paint()
    private val path = Path()
    private val overlayColor = Color.argb(128,135,98,255)

    override fun onDraw(canvas: Canvas?) {
        paint.style = Paint.Style.FILL
        paint.color = overlayColor

        for (i in 0..width) {
            val x = i.toFloat()
            val phase = Math.PI * i / width
            val y = sin(2 * Math.PI - phase) * 20.dp + 50.dp
            path.lineTo(x, y.toFloat())
        }

        path.lineTo(width.toFloat(), height.toFloat())
        path.lineTo(0f, height.toFloat())
        path.close()

        canvas?.drawPath(path, paint)

        super.onDraw(canvas)
    }
}