REPORT zdemo_edit_sum_alv.

TYPE-POOLS: lvc.

*---------------------------------------------------------------------*
* 教学案例：
* 可编辑 OO ALV + 金额自动计算 + 合计
*
* 使用对象：
* CL_GUI_ALV_GRID
*
* 教学重点：
* 1. Field Catalog 控制哪些列可编辑
* 2. DO_SUM 控制金额合计
* 3. DATA_CHANGED 事件检查用户输入
* 4. DATA_CHANGED_FINISHED 事件刷新 ALV
* 5. Toolbar 自定义按钮
* 6. CHECK_CHANGED_DATA 取得用户在画面上还没回写到内表的数据
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* ALV输出结构
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_alv,
         sel         TYPE c LENGTH 1,      "选择框
         item_no     TYPE n LENGTH 4,      "明细番号
         matnr       TYPE mara-matnr,      "品目
         maktx       TYPE makt-maktx,      "品目テキスト
         qty         TYPE vbap-kwmeng,     "数量
         unit        TYPE vbap-vrkme,      "単位
         price       TYPE vbap-netwr,      "単価
         amount      TYPE vbap-netwr,      "金額
         currency    TYPE vbak-waerk,      "通貨
         status_text TYPE char20,          "状態
         line_color  TYPE char4,           "行颜色控制
       END OF ty_alv.

*---------------------------------------------------------------------*
* 主类定义
*---------------------------------------------------------------------*
CLASS lcl_app DEFINITION.

  PUBLIC SECTION.
    METHODS:
      run.

  PRIVATE SECTION.

    DATA:
      mt_alv      TYPE STANDARD TABLE OF ty_alv,
      ms_alv      TYPE ty_alv,

      mt_fieldcat TYPE lvc_t_fcat,
      ms_fieldcat TYPE lvc_s_fcat,

      ms_layout   TYPE lvc_s_layo,

      mo_grid     TYPE REF TO cl_gui_alv_grid.

    METHODS:
      prepare_data,
      build_fieldcat,
      build_layout,
      display_alv,
      refresh_alv,

      add_fieldcat
        IMPORTING
          iv_fieldname TYPE lvc_fname
          iv_coltext   TYPE lvc_txtcol
          iv_edit      TYPE c DEFAULT space
          iv_key       TYPE c DEFAULT space
          iv_checkbox  TYPE c DEFAULT space
          iv_do_sum    TYPE c DEFAULT space
          iv_no_out    TYPE c DEFAULT space
          iv_outputlen TYPE i DEFAULT 10,

      recalculate_all,
      recalculate_one
        CHANGING
          cs_alv TYPE ty_alv,

      check_changed_data
        RETURNING
          VALUE(rv_valid) TYPE c,

      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
          e_object
          e_interactive,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
          e_ucomm,

      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING
          er_data_changed,

      handle_data_changed_finished
        FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING
          e_modified
          et_good_cells.

ENDCLASS.

*---------------------------------------------------------------------*
* 主类实现
*---------------------------------------------------------------------*
CLASS lcl_app IMPLEMENTATION.

  METHOD run.

    me->prepare_data( ).
    me->build_fieldcat( ).
    me->build_layout( ).
    me->display_alv( ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* 准备模拟数据
*---------------------------------------------------------------------*
  METHOD prepare_data.

    CLEAR mt_alv.

    CLEAR ms_alv.
    ms_alv-sel      = space.
    ms_alv-item_no  = '0010'.
    ms_alv-matnr    = 'MAT-001'.
    ms_alv-maktx    = '教学用商品A'.
    ms_alv-qty      = 10.
    ms_alv-unit     = 'PC'.
    ms_alv-price    = 1200.
    ms_alv-currency = 'JPY'.
    APPEND ms_alv TO mt_alv.

    CLEAR ms_alv.
    ms_alv-sel      = space.
    ms_alv-item_no  = '0020'.
    ms_alv-matnr    = 'MAT-002'.
    ms_alv-maktx    = '教学用商品B'.
    ms_alv-qty      = 5.
    ms_alv-unit     = 'PC'.
    ms_alv-price    = 3500.
    ms_alv-currency = 'JPY'.
    APPEND ms_alv TO mt_alv.

    CLEAR ms_alv.
    ms_alv-sel      = space.
    ms_alv-item_no  = '0030'.
    ms_alv-matnr    = 'MAT-003'.
    ms_alv-maktx    = '教学用商品C'.
    ms_alv-qty      = 20.
    ms_alv-unit     = 'PC'.
    ms_alv-price    = 800.
    ms_alv-currency = 'JPY'.
    APPEND ms_alv TO mt_alv.

    CLEAR ms_alv.
    ms_alv-sel      = space.
    ms_alv-item_no  = '0040'.
    ms_alv-matnr    = 'MAT-004'.
    ms_alv-maktx    = '教学用商品D'.
    ms_alv-qty      = 0.
    ms_alv-unit     = 'PC'.
    ms_alv-price    = 1500.
    ms_alv-currency = 'JPY'.
    APPEND ms_alv TO mt_alv.

    "初始金额计算
    me->recalculate_all( ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* 创建 Field Catalog
*---------------------------------------------------------------------*
  METHOD build_fieldcat.

    FIELD-SYMBOLS:
      <ls_fieldcat> TYPE lvc_s_fcat.

    CLEAR mt_fieldcat.

    me->add_fieldcat(
      iv_fieldname = 'SEL'
      iv_coltext   = '選択'
      iv_edit      = 'X'
      iv_checkbox  = 'X'
      iv_outputlen = 6 ).

    me->add_fieldcat(
      iv_fieldname = 'ITEM_NO'
      iv_coltext   = '明細'
      iv_key       = 'X'
      iv_outputlen = 8 ).

    me->add_fieldcat(
      iv_fieldname = 'MATNR'
      iv_coltext   = '品目'
      iv_key       = 'X'
      iv_outputlen = 18 ).

    me->add_fieldcat(
      iv_fieldname = 'MAKTX'
      iv_coltext   = '品目テキスト'
      iv_outputlen = 30 ).

    me->add_fieldcat(
      iv_fieldname = 'QTY'
      iv_coltext   = '数量'
      iv_edit      = 'X'
      iv_do_sum    = 'X'
      iv_outputlen = 15 ).

    me->add_fieldcat(
      iv_fieldname = 'UNIT'
      iv_coltext   = '単位'
      iv_outputlen = 8 ).

    me->add_fieldcat(
      iv_fieldname = 'PRICE'
      iv_coltext   = '単価'
      iv_edit      = 'X'
      iv_outputlen = 15 ).

    me->add_fieldcat(
      iv_fieldname = 'AMOUNT'
      iv_coltext   = '金額'
      iv_do_sum    = 'X'
      iv_outputlen = 18 ).

    me->add_fieldcat(
      iv_fieldname = 'CURRENCY'
      iv_coltext   = '通貨'
      iv_outputlen = 8 ).

    me->add_fieldcat(
      iv_fieldname = 'STATUS_TEXT'
      iv_coltext   = '状態'
      iv_outputlen = 15 ).

    me->add_fieldcat(
      iv_fieldname = 'LINE_COLOR'
      iv_coltext   = '行色'
      iv_no_out    = 'X'
      iv_outputlen = 4 ).

    "数量字段和单位字段关联
    READ TABLE mt_fieldcat ASSIGNING <ls_fieldcat>
      WITH KEY fieldname = 'QTY'.

    IF sy-subrc = 0.
      <ls_fieldcat>-qfieldname = 'UNIT'.
    ENDIF.

    "单价字段和通货字段关联
    READ TABLE mt_fieldcat ASSIGNING <ls_fieldcat>
      WITH KEY fieldname = 'PRICE'.

    IF sy-subrc = 0.
      <ls_fieldcat>-cfieldname = 'CURRENCY'.
    ENDIF.

    "金额字段和通货字段关联
    READ TABLE mt_fieldcat ASSIGNING <ls_fieldcat>
      WITH KEY fieldname = 'AMOUNT'.

    IF sy-subrc = 0.
      <ls_fieldcat>-cfieldname = 'CURRENCY'.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 追加 Field Catalog
*---------------------------------------------------------------------*
  METHOD add_fieldcat.

    CLEAR ms_fieldcat.

    ms_fieldcat-fieldname = iv_fieldname.

    ms_fieldcat-coltext   = iv_coltext.
    ms_fieldcat-scrtext_l = iv_coltext.
    ms_fieldcat-scrtext_m = iv_coltext.
    ms_fieldcat-scrtext_s = iv_coltext.

    ms_fieldcat-edit      = iv_edit.
    ms_fieldcat-key       = iv_key.
    ms_fieldcat-checkbox  = iv_checkbox.
    ms_fieldcat-do_sum    = iv_do_sum.
    ms_fieldcat-no_out    = iv_no_out.
    ms_fieldcat-outputlen = iv_outputlen.

    APPEND ms_fieldcat TO mt_fieldcat.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 创建 Layout
*---------------------------------------------------------------------*
  METHOD build_layout.

    CLEAR ms_layout.

    "斑马纹
    ms_layout-zebra = 'X'.

    "自动列宽
    ms_layout-cwidth_opt = 'X'.

    "多选模式
    ms_layout-sel_mode = 'A'.

    "标题
    ms_layout-grid_title = '可编辑 ALV：数量 × 単価 = 金額，金額自动合计'.

    "行颜色控制字段
    ms_layout-info_fname = 'LINE_COLOR'.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 显示 ALV
*---------------------------------------------------------------------*
  METHOD display_alv.

    CREATE OBJECT mo_grid
      EXPORTING
        i_parent = cl_gui_container=>default_screen.

    "注册事件
    SET HANDLER me->handle_toolbar               FOR mo_grid.
    SET HANDLER me->handle_user_command          FOR mo_grid.
    SET HANDLER me->handle_data_changed          FOR mo_grid.
    SET HANDLER me->handle_data_changed_finished FOR mo_grid.

    "注册编辑事件：按 Enter 时触发 DATA_CHANGED
    CALL METHOD mo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    "注册编辑事件：单元格修改后触发 DATA_CHANGED
    CALL METHOD mo_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    CALL METHOD mo_grid->set_table_for_first_display
      EXPORTING
        is_layout       = ms_layout
        i_save          = 'A'
        i_default       = 'X'
      CHANGING
        it_outtab       = mt_alv
        it_fieldcatalog = mt_fieldcat.

    "打开可编辑状态
    CALL METHOD mo_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

    CALL METHOD cl_gui_cfw=>flush.

    "DEFAULT_SCREEN 必须有一个 WRITE 触发标准画面
    WRITE space.

  ENDMETHOD.

*---------------------------------------------------------------------*
* Toolbar追加按钮
*---------------------------------------------------------------------*
  METHOD handle_toolbar.

    DATA:
      ls_toolbar TYPE stb_button.

    CLEAR ls_toolbar.
    ls_toolbar-butn_type = 3. "分隔线
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function  = 'RECALC'.
    ls_toolbar-text      = '重新计算'.
    ls_toolbar-quickinfo = '根据数量和单价重新计算金额'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function  = 'CHECK_SAVE'.
    ls_toolbar-text      = '保存检查'.
    ls_toolbar-quickinfo = '检查输入内容，模拟保存'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

*---------------------------------------------------------------------*
* Toolbar按钮事件
*---------------------------------------------------------------------*
  METHOD handle_user_command.

    DATA:
      lv_valid TYPE c.

    CASE e_ucomm.

      WHEN 'RECALC'.

        lv_valid = me->check_changed_data( ).

        IF lv_valid IS INITIAL.
          MESSAGE '输入内容有错误，请修正后再重新计算。' TYPE 'I'.
          RETURN.
        ENDIF.

        me->recalculate_all( ).
        me->refresh_alv( ).

        MESSAGE '重新计算完成。' TYPE 'S'.

      WHEN 'CHECK_SAVE'.

        lv_valid = me->check_changed_data( ).

        IF lv_valid IS INITIAL.
          MESSAGE '输入内容有错误，不能保存。' TYPE 'I'.
          RETURN.
        ENDIF.

        me->recalculate_all( ).
        me->refresh_alv( ).

        "教学案例不更新数据库
        MESSAGE '检查完成。教学版只模拟保存，不更新数据库。' TYPE 'S'.

    ENDCASE.

  ENDMETHOD.

*---------------------------------------------------------------------*
* ALV数据修改事件
*---------------------------------------------------------------------*
  METHOD handle_data_changed.

    DATA:
      ls_modi   TYPE lvc_s_modi,
      lv_qty    TYPE vbap-kwmeng,
      lv_price  TYPE vbap-netwr,
      lv_amount TYPE vbap-netwr,
      lv_status TYPE char20,
      lv_color  TYPE char4.

    LOOP AT er_data_changed->mt_good_cells INTO ls_modi
      WHERE fieldname = 'QTY'
         OR fieldname = 'PRICE'.

      CLEAR:
        lv_qty,
        lv_price,
        lv_amount,
        lv_status,
        lv_color.

      "取得当前行的数量
      CALL METHOD er_data_changed->get_cell_value
        EXPORTING
          i_row_id    = ls_modi-row_id
          i_fieldname = 'QTY'
        IMPORTING
          e_value     = lv_qty.

      "取得当前行的单价
      CALL METHOD er_data_changed->get_cell_value
        EXPORTING
          i_row_id    = ls_modi-row_id
          i_fieldname = 'PRICE'
        IMPORTING
          e_value     = lv_price.

      "输入检查：数量不能小于0
      IF lv_qty < 0.

        CALL METHOD er_data_changed->add_protocol_entry
          EXPORTING
            i_msgid     = '00'
            i_msgno     = '398'
            i_msgty     = 'E'
            i_msgv1     = '数量不能小于0'
            i_fieldname = 'QTY'
            i_row_id    = ls_modi-row_id.

        CONTINUE.

      ENDIF.

      "输入检查：单价不能小于0
      IF lv_price < 0.

        CALL METHOD er_data_changed->add_protocol_entry
          EXPORTING
            i_msgid     = '00'
            i_msgno     = '398'
            i_msgty     = 'E'
            i_msgv1     = '单价不能小于0'
            i_fieldname = 'PRICE'
            i_row_id    = ls_modi-row_id.

        CONTINUE.

      ENDIF.

      "重新计算金额
      lv_amount = lv_qty * lv_price.

      IF lv_qty IS INITIAL OR lv_price IS INITIAL.
        lv_status = '未入力'.
        lv_color  = 'C310'. "黄色
      ELSE.
        lv_status = '計算済'.
        lv_color  = 'C510'. "绿色
      ENDIF.

      "把计算后的金额回写到 ALV 单元格
      CALL METHOD er_data_changed->modify_cell
        EXPORTING
          i_row_id    = ls_modi-row_id
          i_fieldname = 'AMOUNT'
          i_value     = lv_amount.

      "状态文本回写
      CALL METHOD er_data_changed->modify_cell
        EXPORTING
          i_row_id    = ls_modi-row_id
          i_fieldname = 'STATUS_TEXT'
          i_value     = lv_status.

      "行颜色字段回写
      CALL METHOD er_data_changed->modify_cell
        EXPORTING
          i_row_id    = ls_modi-row_id
          i_fieldname = 'LINE_COLOR'
          i_value     = lv_color.

    ENDLOOP.

  ENDMETHOD.

*---------------------------------------------------------------------*
* ALV数据修改完成事件
*---------------------------------------------------------------------*
  METHOD handle_data_changed_finished.

    IF e_modified IS INITIAL.
      RETURN.
    ENDIF.

    "为了保证合计行和内表一致，再统一计算一次
    me->recalculate_all( ).
    me->refresh_alv( ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* 检查画面上被修改但还没回写到内表的数据
*---------------------------------------------------------------------*
  METHOD check_changed_data.

    rv_valid = 'X'.

    IF mo_grid IS BOUND.

      CALL METHOD mo_grid->check_changed_data
        IMPORTING
          e_valid = rv_valid.

    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 全件重新计算
*---------------------------------------------------------------------*
  METHOD recalculate_all.

    FIELD-SYMBOLS:
      <ls_alv> TYPE ty_alv.

    LOOP AT mt_alv ASSIGNING <ls_alv>.
      me->recalculate_one(
        CHANGING
          cs_alv = <ls_alv> ).
    ENDLOOP.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 单行重新计算
*---------------------------------------------------------------------*
  METHOD recalculate_one.

    IF cs_alv-qty < 0 OR cs_alv-price < 0.

      cs_alv-amount      = 0.
      cs_alv-status_text = '入力エラー'.
      cs_alv-line_color  = 'C610'. "红色

    ELSE.

      cs_alv-amount = cs_alv-qty * cs_alv-price.

      IF cs_alv-qty IS INITIAL OR cs_alv-price IS INITIAL.
        cs_alv-status_text = '未入力'.
        cs_alv-line_color  = 'C310'. "黄色
      ELSE.
        cs_alv-status_text = '計算済'.
        cs_alv-line_color  = 'C510'. "绿色
      ENDIF.

    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* 刷新 ALV
*---------------------------------------------------------------------*
  METHOD refresh_alv.

    DATA:
      ls_stable TYPE lvc_s_stbl.

    IF mo_grid IS NOT BOUND.
      RETURN.
    ENDIF.

    "刷新后保持当前行和当前列位置
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD mo_grid->refresh_table_display
      EXPORTING
        is_stable = ls_stable.

  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* 程序入口
*---------------------------------------------------------------------*
DATA:
  go_app TYPE REF TO lcl_app.

START-OF-SELECTION.

  CREATE OBJECT go_app.
  go_app->run( ).
