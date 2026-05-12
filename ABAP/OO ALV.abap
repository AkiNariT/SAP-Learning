REPORT zsd_demo_edit_alv.

*-----------------------------------------------------------------------
* 教学目的：
*   1. 上方 ALV 显示受注传票列表 VBAK
*   2. 双击某个受注后，下方 ALV 显示受注明细 VBAP
*   3. 明细 ALV 可以合计数量、金额
*   4. 明细数量 KWMENG 可以修改
*   5. 点击保存按钮后，模拟保存修改结果
*
* 重要：
*   本 Demo 不直接 UPDATE 标准表 VBAP。
*   正式项目里如果要修改受注数量，应使用 BAPI_SALESORDER_CHANGE。
*-----------------------------------------------------------------------

TABLES: vbak.

*-----------------------------------------------------------------------
* 选择画面
*-----------------------------------------------------------------------
SELECT-OPTIONS:
  s_vbeln FOR vbak-vbeln.

PARAMETERS:
  p_max TYPE i DEFAULT 50.

*-----------------------------------------------------------------------
* 类型定义：受注ヘッダ
*-----------------------------------------------------------------------
TYPES: BEGIN OF ty_head,
         vbeln TYPE vbak-vbeln,   "受注番号
         auart TYPE vbak-auart,   "販売伝票タイプ
         kunnr TYPE vbak-kunnr,   "得意先
         erdat TYPE vbak-erdat,   "登録日
         waerk TYPE vbak-waerk,   "通貨
       END OF ty_head.

*-----------------------------------------------------------------------
* 类型定义：受注明細
*-----------------------------------------------------------------------
TYPES: BEGIN OF ty_item,
         vbeln      TYPE vbap-vbeln,   "受注番号
         posnr      TYPE vbap-posnr,   "明細番号
         matnr      TYPE vbap-matnr,   "品目
         arktx      TYPE vbap-arktx,   "品目テキスト
         kwmeng     TYPE vbap-kwmeng,  "受注数量：可编辑
         orig_kwmeng TYPE vbap-kwmeng, "原始数量：用于判断是否修改
         vrkme      TYPE vbap-vrkme,   "販売単位
         netwr      TYPE vbap-netwr,   "金額：演示中根据数量重新计算
         waerk      TYPE vbak-waerk,   "通貨
         unit_price TYPE p LENGTH 15 DECIMALS 4, "单价：教学用
         changed    TYPE c LENGTH 1,   "是否修改
         status     TYPE c LENGTH 20,  "保存状态
       END OF ty_item.

*-----------------------------------------------------------------------
* 全局数据
*-----------------------------------------------------------------------
DATA:
  gt_head TYPE STANDARD TABLE OF ty_head WITH EMPTY KEY,
  gt_item TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.

DATA:
  gv_current_vbeln TYPE vbak-vbeln,
  gv_current_waerk TYPE vbak-waerk.

*-----------------------------------------------------------------------
* ALV 相关对象
*-----------------------------------------------------------------------
DATA:
  go_dock       TYPE REF TO cl_gui_docking_container,
  go_splitter   TYPE REF TO cl_gui_splitter_container,
  go_cont_head  TYPE REF TO cl_gui_container,
  go_cont_item  TYPE REF TO cl_gui_container,
  go_grid_head  TYPE REF TO cl_gui_alv_grid,
  go_grid_item  TYPE REF TO cl_gui_alv_grid,
  go_handler    TYPE REF TO lcl_event_handler.

DATA:
  gt_fcat_head TYPE lvc_t_fcat,
  gt_fcat_item TYPE lvc_t_fcat,
  gs_layout    TYPE lvc_s_layo.

*-----------------------------------------------------------------------
* 事件处理类
*-----------------------------------------------------------------------
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.

    METHODS:
      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column sender,

      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive sender,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm sender.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.

    "只处理上方受注列表的双击事件
    IF sender <> go_grid_head.
      RETURN.
    ENDIF.

    READ TABLE gt_head INTO DATA(ls_head) INDEX e_row-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    gv_current_vbeln = ls_head-vbeln.
    gv_current_waerk = ls_head-waerk.

    PERFORM get_item_data USING gv_current_vbeln gv_current_waerk.
    PERFORM refresh_item_alv.

    MESSAGE |受注 { gv_current_vbeln } の明細を表示しました。| TYPE 'S'.

  ENDMETHOD.

  METHOD handle_toolbar.

    DATA ls_button TYPE stb_button.

    CLEAR ls_button.

    IF sender = go_grid_head.

      "上方 ALV：追加退出按钮
      ls_button-function  = 'EXIT'.
      ls_button-icon      = icon_system_end.
      ls_button-quickinfo = '退出程序'.
      ls_button-text      = '退出'.
      APPEND ls_button TO e_object->mt_toolbar.

    ELSEIF sender = go_grid_item.

      "下方 ALV：追加保存按钮
      ls_button-function  = 'SAVE'.
      ls_button-icon      = icon_system_save.
      ls_button-quickinfo = '保存修改'.
      ls_button-text      = '保存修改'.
      APPEND ls_button TO e_object->mt_toolbar.

    ENDIF.

  ENDMETHOD.

  METHOD handle_user_command.

    CASE e_ucomm.

      WHEN 'EXIT'.
        LEAVE PROGRAM.

      WHEN 'SAVE'.
        IF sender = go_grid_item.
          PERFORM save_item_data.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
*-----------------------------------------------------------------------
* 主处理
*-----------------------------------------------------------------------
START-OF-SELECTION.

  PERFORM get_head_data.

  IF gt_head IS INITIAL.
    MESSAGE '該当する受注データがありません。' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL SCREEN 0100.
*-----------------------------------------------------------------------
* 取得受注ヘッダ数据
*-----------------------------------------------------------------------
FORM get_head_data.

  SELECT vbeln,
         auart,
         kunnr,
         erdat,
         waerk
    FROM vbak
    INTO TABLE @gt_head
    WHERE vbeln IN @s_vbeln
    UP TO @p_max ROWS.

ENDFORM.
*-----------------------------------------------------------------------
* 取得受注明細数据
*-----------------------------------------------------------------------
FORM get_item_data USING pv_vbeln TYPE vbak-vbeln
                         pv_waerk TYPE vbak-waerk.

  CLEAR gt_item.

  SELECT vbeln,
         posnr,
         matnr,
         arktx,
         kwmeng,
         vrkme,
         netwr
    FROM vbap
    INTO TABLE @DATA(lt_vbap)
    WHERE vbeln = @pv_vbeln.

  LOOP AT lt_vbap INTO DATA(ls_vbap).

    DATA(lv_unit_price) = COND p(
      WHEN ls_vbap-kwmeng IS NOT INITIAL
      THEN ls_vbap-netwr / ls_vbap-kwmeng
      ELSE 0
    ).

    APPEND VALUE ty_item(
      vbeln       = ls_vbap-vbeln
      posnr       = ls_vbap-posnr
      matnr       = ls_vbap-matnr
      arktx       = ls_vbap-arktx
      kwmeng      = ls_vbap-kwmeng
      orig_kwmeng = ls_vbap-kwmeng
      vrkme       = ls_vbap-vrkme
      netwr       = ls_vbap-netwr
      waerk       = pv_waerk
      unit_price  = lv_unit_price
      changed     = space
      status      = space
    ) TO gt_item.

  ENDLOOP.

ENDFORM.

*-----------------------------------------------------------------------
* PBO
*-----------------------------------------------------------------------
MODULE pbo_0100 OUTPUT.

  IF go_dock IS INITIAL.
    PERFORM create_alv_screen.
  ENDIF.

ENDMODULE.

*-----------------------------------------------------------------------
* PAI
*-----------------------------------------------------------------------
MODULE pai_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.

*-----------------------------------------------------------------------
* 创建 ALV 画面
*-----------------------------------------------------------------------
FORM create_alv_screen.

  "创建 Docking Container，占满当前屏幕
  CREATE OBJECT go_dock
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      side      = cl_gui_docking_container=>dock_at_left
      extension = 9999.

  "创建上下分割容器
  CREATE OBJECT go_splitter
    EXPORTING
      parent  = go_dock
      rows    = 2
      columns = 1.

  go_cont_head = go_splitter->get_container(
    row    = 1
    column = 1
  ).

  go_cont_item = go_splitter->get_container(
    row    = 2
    column = 1
  ).

  "设置上下高度比例
  go_splitter->set_row_height(
    id     = 1
    height = 40
  ).

  go_splitter->set_row_height(
    id     = 2
    height = 60
  ).

  "创建两个 ALV Grid
  CREATE OBJECT go_grid_head
    EXPORTING
      i_parent = go_cont_head.

  CREATE OBJECT go_grid_item
    EXPORTING
      i_parent = go_cont_item.

  "创建事件处理对象
  CREATE OBJECT go_handler.

  SET HANDLER go_handler->handle_double_click FOR go_grid_head.
  SET HANDLER go_handler->handle_toolbar      FOR go_grid_head.
  SET HANDLER go_handler->handle_user_command FOR go_grid_head.

  SET HANDLER go_handler->handle_toolbar      FOR go_grid_item.
  SET HANDLER go_handler->handle_user_command FOR go_grid_item.

  "构建 Field Catalog
  PERFORM build_fcat_head.
  PERFORM build_fcat_item.

  "显示两个 ALV
  PERFORM display_head_alv.
  PERFORM display_item_alv.

ENDFORM.

*-----------------------------------------------------------------------
* 构建上方受注 ALV Field Catalog
*-----------------------------------------------------------------------
FORM build_fcat_head.

  CLEAR gt_fcat_head.

  PERFORM add_fcat_head USING 'VBELN' '受注番号'        '' ''.
  PERFORM add_fcat_head USING 'AUART' '販売伝票タイプ'  '' ''.
  PERFORM add_fcat_head USING 'KUNNR' '得意先'          '' ''.
  PERFORM add_fcat_head USING 'ERDAT' '登録日'          '' ''.
  PERFORM add_fcat_head USING 'WAERK' '通貨'            '' ''.

ENDFORM.

FORM add_fcat_head USING pv_field TYPE fieldname
                         pv_text  TYPE scrtext_l
                         pv_edit  TYPE c
                         pv_sum   TYPE c.

  DATA ls_fcat TYPE lvc_s_fcat.

  ls_fcat-fieldname = pv_field.
  ls_fcat-coltext   = pv_text.
  ls_fcat-scrtext_l = pv_text.
  ls_fcat-scrtext_m = pv_text.
  ls_fcat-scrtext_s = pv_text.

  IF pv_edit = abap_true.
    ls_fcat-edit = abap_true.
  ENDIF.

  IF pv_sum = abap_true.
    ls_fcat-do_sum = abap_true.
  ENDIF.

  APPEND ls_fcat TO gt_fcat_head.

ENDFORM.

*-----------------------------------------------------------------------
* 构建下方明细 ALV Field Catalog
*-----------------------------------------------------------------------
FORM build_fcat_item.

  CLEAR gt_fcat_item.

  PERFORM add_fcat_item USING 'VBELN'       '受注番号'     ''          ''.
  PERFORM add_fcat_item USING 'POSNR'       '明細'         ''          ''.
  PERFORM add_fcat_item USING 'MATNR'       '品目'         ''          ''.
  PERFORM add_fcat_item USING 'ARKTX'       '品目名称'     ''          ''.
  PERFORM add_fcat_item USING 'KWMENG'      '受注数量'     abap_true   abap_true.
  PERFORM add_fcat_item USING 'VRKME'       '単位'         ''          ''.
  PERFORM add_fcat_item USING 'NETWR'       '金額'         ''          abap_true.
  PERFORM add_fcat_item USING 'WAERK'       '通貨'         ''          ''.
  PERFORM add_fcat_item USING 'CHANGED'     '変更'         ''          ''.
  PERFORM add_fcat_item USING 'STATUS'      '保存状態'     ''          ''.

  "教学用单价、原始数量一般不显示
  PERFORM add_fcat_item USING 'UNIT_PRICE'  '単価'         ''          ''.
  PERFORM add_fcat_item USING 'ORIG_KWMENG' '元数量'       ''          ''.

  LOOP AT gt_fcat_item ASSIGNING FIELD-SYMBOL(<ls_fcat>).
    IF <ls_fcat>-fieldname = 'UNIT_PRICE'
    OR <ls_fcat>-fieldname = 'ORIG_KWMENG'.
      <ls_fcat>-no_out = abap_true.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM add_fcat_item USING pv_field TYPE fieldname
                         pv_text  TYPE scrtext_l
                         pv_edit  TYPE c
                         pv_sum   TYPE c.

  DATA ls_fcat TYPE lvc_s_fcat.

  ls_fcat-fieldname = pv_field.
  ls_fcat-coltext   = pv_text.
  ls_fcat-scrtext_l = pv_text.
  ls_fcat-scrtext_m = pv_text.
  ls_fcat-scrtext_s = pv_text.

  IF pv_edit = abap_true.
    ls_fcat-edit = abap_true.
  ENDIF.

  IF pv_sum = abap_true.
    ls_fcat-do_sum = abap_true.
  ENDIF.

  APPEND ls_fcat TO gt_fcat_item.

ENDFORM.

*-----------------------------------------------------------------------
* 显示上方受注 ALV
*-----------------------------------------------------------------------
FORM display_head_alv.

  CLEAR gs_layout.

  gs_layout-zebra      = abap_true.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode   = 'A'.

  go_grid_head->set_table_for_first_display(
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_head
      it_fieldcatalog = gt_fcat_head
  ).

  go_grid_head->set_toolbar_interactive( ).

ENDFORM.

*-----------------------------------------------------------------------
* 显示下方明细 ALV
*-----------------------------------------------------------------------
FORM display_item_alv.

  CLEAR gs_layout.

  gs_layout-zebra      = abap_true.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode   = 'A'.
  gs_layout-edit       = abap_true.

  go_grid_item->set_table_for_first_display(
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_item
      it_fieldcatalog = gt_fcat_item
  ).

  "允许单元格修改后触发变更
  go_grid_item->register_edit_event(
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified
  ).

  "设置为可输入状态
  go_grid_item->set_ready_for_input( 1 ).

  go_grid_item->set_toolbar_interactive( ).

ENDFORM.

*-----------------------------------------------------------------------
* 刷新明细 ALV
*-----------------------------------------------------------------------
FORM refresh_item_alv.

  DATA ls_stable TYPE lvc_s_stbl.

  ls_stable-row = abap_true.
  ls_stable-col = abap_true.

  go_grid_item->refresh_table_display(
    EXPORTING
      is_stable = ls_stable
  ).

ENDFORM.

*-----------------------------------------------------------------------
* 保存明细数据
*-----------------------------------------------------------------------
FORM save_item_data.

  IF gv_current_vbeln IS INITIAL.
    MESSAGE '先双击一张受注，再修改明细。' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "把前台 ALV 修改同步回内表 gt_item
  go_grid_item->check_changed_data( ).

  DATA(lv_changed_count) = 0.

  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

    "判断数量是否被修改
    IF <ls_item>-kwmeng <> <ls_item>-orig_kwmeng.

      lv_changed_count = lv_changed_count + 1.

      "教学用：根据单价重新计算金额
      <ls_item>-netwr = <ls_item>-kwmeng * <ls_item>-unit_price.

      <ls_item>-changed = abap_true.
      <ls_item>-status  = '保存済み(演示)'.

      "保存后把当前数量作为新的原始数量
      <ls_item>-orig_kwmeng = <ls_item>-kwmeng.

    ENDIF.

  ENDLOOP.

  IF lv_changed_count = 0.
    MESSAGE '変更された明細はありません。' TYPE 'S'.
    RETURN.
  ENDIF.

  "正式项目注意：
  "这里不要 UPDATE VBAP。
  "如果真实修改受注数量，应该调用 BAPI_SALESORDER_CHANGE。
  "
  "示意：
  " PERFORM save_by_bapi_salesorder_change.

  PERFORM refresh_item_alv.

  MESSAGE |{ lv_changed_count } 件の明細を保存しました。※教学模拟保存| TYPE 'S'.

ENDFORM.
