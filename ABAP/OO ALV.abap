REPORT zdemo_oo_alv_sd_so.

TYPE-POOLS: lvc.

TABLES: vbak, vbap.

*---------------------------------------------------------------------*
* 教学案例：OO ALV 显示 SD 受注数据
*
* 主要目的：
* 1. 理解 OO ALV 的基本结构
* 2. 理解 Field Catalog 是如何控制 ALV 列显示的
* 3. 理解 Layout 是如何控制 ALV 整体外观的
* 4. 理解 ALV 事件，例如双击、热点点击
*
* 使用对象：
* - CL_GUI_ALV_GRID
* - CL_GUI_CONTAINER=>DEFAULT_SCREEN
*
* 数据来源：
* - VBAK：销售凭证抬头 / 受注ヘッダ
* - VBAP：销售凭证明细 / 受注明細
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* ALV 输出结构
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_alv,
         vbeln       TYPE vbak-vbeln,     "受注番号
         posnr       TYPE vbap-posnr,     "明細番号
         auart       TYPE vbak-auart,     "受注タイプ
         vkorg       TYPE vbak-vkorg,     "販売組織
         vtweg       TYPE vbak-vtweg,     "流通チャネル
         spart       TYPE vbak-spart,     "製品部門
         kunnr       TYPE vbak-kunnr,     "得意先
         erdat       TYPE vbak-erdat,     "登録日
         matnr       TYPE vbap-matnr,     "品目
         arktx       TYPE vbap-arktx,     "品目テキスト
         kwmeng      TYPE vbap-kwmeng,    "受注数量
         vrkme       TYPE vbap-vrkme,     "販売単位
         netwr       TYPE vbap-netwr,     "正味金額
         waerk       TYPE vbak-waerk,     "通貨
         status_text TYPE char20,         "教学用状态文本
       END OF ty_alv.

*---------------------------------------------------------------------*
* 选择画面
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

SELECT-OPTIONS:
  s_vbeln FOR vbak-vbeln,    "受注番号
  s_erdat FOR vbak-erdat,    "登録日
  s_matnr FOR vbap-matnr.    "品目

PARAMETERS:
  p_max TYPE i DEFAULT 200.  "最大取得件数

SELECTION-SCREEN END OF BLOCK b1.

*---------------------------------------------------------------------*
* 选择画面检查
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF p_max <= 0.
    MESSAGE '最大取得件数必须大于 0' TYPE 'E'.
  ENDIF.

*---------------------------------------------------------------------*
* 主处理类定义
*---------------------------------------------------------------------*
CLASS lcl_app DEFINITION.

  PUBLIC SECTION.

    METHODS:
      run.

  PRIVATE SECTION.

    DATA:
      mt_alv      TYPE STANDARD TABLE OF ty_alv,  "ALV显示用内表
      ms_alv      TYPE ty_alv,                    "ALV工作区
      mt_fieldcat TYPE lvc_t_fcat,                "字段目录
      ms_layout   TYPE lvc_s_layo,                "ALV布局
      mo_grid     TYPE REF TO cl_gui_alv_grid.    "ALV对象

    METHODS:
      get_data,
      build_fieldcat,
      build_layout,
      display_alv,

      add_fieldcat
        IMPORTING
          iv_fieldname TYPE lvc_fname
          iv_coltext   TYPE lvc_txtcol
          iv_outputlen TYPE i DEFAULT 10
          iv_key       TYPE c DEFAULT space
          iv_hotspot   TYPE c DEFAULT space
          iv_do_sum    TYPE c DEFAULT space
          iv_no_zero   TYPE c DEFAULT space,

      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column,

      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id.

ENDCLASS.

*---------------------------------------------------------------------*
* 主处理类实现
*---------------------------------------------------------------------*
CLASS lcl_app IMPLEMENTATION.

  METHOD run.

    "1. 取得数据
    me->get_data( ).

    IF mt_alv IS INITIAL.
      MESSAGE '没有取到数据，请放宽选择条件。' TYPE 'I'.
      RETURN.
    ENDIF.

    "2. 构建 Field Catalog
    me->build_fieldcat( ).

    "3. 构建 Layout
    me->build_layout( ).

    "4. 显示 ALV
    me->display_alv( ).

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS:
      <ls_alv> TYPE ty_alv.

    CLEAR mt_alv.

    SELECT a~vbeln
           b~posnr
           a~auart
           a~vkorg
           a~vtweg
           a~spart
           a~kunnr
           a~erdat
           b~matnr
           b~arktx
           b~kwmeng
           b~vrkme
           b~netwr
           a~waerk
      FROM vbak AS a
      INNER JOIN vbap AS b
        ON b~vbeln = a~vbeln
      INTO CORRESPONDING FIELDS OF TABLE mt_alv
      UP TO p_max ROWS
      WHERE a~vbeln IN s_vbeln
        AND a~erdat IN s_erdat
        AND b~matnr IN s_matnr
      ORDER BY a~vbeln b~posnr.

    "教学用：给每一行追加一个简单状态文本
    LOOP AT mt_alv ASSIGNING <ls_alv>.

      IF <ls_alv>-kwmeng IS INITIAL.
        <ls_alv>-status_text = '数量为空'.
      ELSEIF <ls_alv>-netwr IS INITIAL.
        <ls_alv>-status_text = '金额为空'.
      ELSE.
        <ls_alv>-status_text = '正常'.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD build_fieldcat.

    FIELD-SYMBOLS:
      <ls_fcat> TYPE lvc_s_fcat.

    CLEAR mt_fieldcat.

    "KEY字段：通常用于固定重要列
    me->add_fieldcat(
      iv_fieldname = 'VBELN'
      iv_coltext   = '受注番号'
      iv_outputlen = 12
      iv_key       = 'X'
      iv_hotspot   = 'X' ).

    me->add_fieldcat(
      iv_fieldname = 'POSNR'
      iv_coltext   = '明細番号'
      iv_outputlen = 8
      iv_key       = 'X'
      iv_no_zero   = 'X' ).

    me->add_fieldcat(
      iv_fieldname = 'AUART'
      iv_coltext   = '受注タイプ'
      iv_outputlen = 10 ).

    me->add_fieldcat(
      iv_fieldname = 'VKORG'
      iv_coltext   = '販売組織'
      iv_outputlen = 10 ).

    me->add_fieldcat(
      iv_fieldname = 'VTWEG'
      iv_coltext   = '流通チャネル'
      iv_outputlen = 12 ).

    me->add_fieldcat(
      iv_fieldname = 'SPART'
      iv_coltext   = '製品部門'
      iv_outputlen = 10 ).

    me->add_fieldcat(
      iv_fieldname = 'KUNNR'
      iv_coltext   = '得意先'
      iv_outputlen = 12 ).

    me->add_fieldcat(
      iv_fieldname = 'ERDAT'
      iv_coltext   = '登録日'
      iv_outputlen = 10 ).

    me->add_fieldcat(
      iv_fieldname = 'MATNR'
      iv_coltext   = '品目'
      iv_outputlen = 18 ).

    me->add_fieldcat(
      iv_fieldname = 'ARKTX'
      iv_coltext   = '品目テキスト'
      iv_outputlen = 30 ).

    me->add_fieldcat(
      iv_fieldname = 'KWMENG'
      iv_coltext   = '受注数量'
      iv_outputlen = 15
      iv_do_sum    = 'X' ).

    me->add_fieldcat(
      iv_fieldname = 'VRKME'
      iv_coltext   = '販売単位'
      iv_outputlen = 8 ).

    me->add_fieldcat(
      iv_fieldname = 'NETWR'
      iv_coltext   = '正味金額'
      iv_outputlen = 15
      iv_do_sum    = 'X' ).

    me->add_fieldcat(
      iv_fieldname = 'WAERK'
      iv_coltext   = '通貨'
      iv_outputlen = 6 ).

    me->add_fieldcat(
      iv_fieldname = 'STATUS_TEXT'
      iv_coltext   = '状态'
      iv_outputlen = 12 ).

    "数量字段和单位字段关联
    READ TABLE mt_fieldcat ASSIGNING <ls_fcat>
      WITH KEY fieldname = 'KWMENG'.

    IF sy-subrc = 0.
      <ls_fcat>-qfieldname = 'VRKME'.
    ENDIF.

    "金额字段和通货字段关联
    READ TABLE mt_fieldcat ASSIGNING <ls_fcat>
      WITH KEY fieldname = 'NETWR'.

    IF sy-subrc = 0.
      <ls_fcat>-cfieldname = 'WAERK'.
    ENDIF.

  ENDMETHOD.

  METHOD add_fieldcat.

    DATA:
      ls_fcat TYPE lvc_s_fcat.

    CLEAR ls_fcat.

    "ALV内表中的字段名
    ls_fcat-fieldname = iv_fieldname.

    "列标题
    ls_fcat-coltext   = iv_coltext.
    ls_fcat-scrtext_l = iv_coltext.
    ls_fcat-scrtext_m = iv_coltext.
    ls_fcat-scrtext_s = iv_coltext.

    "列宽
    ls_fcat-outputlen = iv_outputlen.

    "是否KEY列
    ls_fcat-key = iv_key.

    "是否热点字段：点击后触发 HOTSPOT_CLICK 事件
    ls_fcat-hotspot = iv_hotspot.

    "是否合计
    ls_fcat-do_sum = iv_do_sum.

    "是否隐藏前导零
    ls_fcat-no_zero = iv_no_zero.

    APPEND ls_fcat TO mt_fieldcat.

  ENDMETHOD.

  METHOD build_layout.

    CLEAR ms_layout.

    "斑马纹显示
    ms_layout-zebra = 'X'.

    "自动优化列宽
    ms_layout-cwidth_opt = 'X'.

    "允许多选
    ms_layout-sel_mode = 'A'.

    "ALV标题
    ms_layout-grid_title = 'SD 受注データ OO ALV 教学案例'.

  ENDMETHOD.

  METHOD display_alv.

    "这里使用 DEFAULT_SCREEN，所以不需要自己创建 0100 画面
    CREATE OBJECT mo_grid
      EXPORTING
        i_parent = cl_gui_container=>default_screen.

    "注册事件：双击
    SET HANDLER me->handle_double_click FOR mo_grid.

    "注册事件：热点点击
    SET HANDLER me->handle_hotspot_click FOR mo_grid.

    "第一次显示 ALV
    CALL METHOD mo_grid->set_table_for_first_display
      EXPORTING
        is_layout       = ms_layout
        i_save          = 'A'      "允许保存用户布局
        i_default       = 'X'
      CHANGING
        it_outtab       = mt_alv
        it_fieldcatalog = mt_fieldcat.

    "刷新前端控制
    CALL METHOD cl_gui_cfw=>flush.

    "使用 DEFAULT_SCREEN 时，需要一个 WRITE 触发标准 List Screen
    WRITE space.

  ENDMETHOD.

  METHOD handle_double_click.

    DATA:
      ls_alv TYPE ty_alv.

    READ TABLE mt_alv INTO ls_alv INDEX e_row-index.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    MESSAGE i398(00)
      WITH '双击行：受注'
           ls_alv-vbeln
           '品目'
           ls_alv-matnr.

  ENDMETHOD.

  METHOD handle_hotspot_click.

    DATA:
      ls_alv TYPE ty_alv.

    READ TABLE mt_alv INTO ls_alv INDEX e_row_id-index.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CASE e_column_id-fieldname.

      WHEN 'VBELN'.

        "点击受注番号时，跳转到 VA03
        SET PARAMETER ID 'AUN' FIELD ls_alv-vbeln.

        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.

      WHEN OTHERS.

        MESSAGE '当前字段没有定义 Hotspot 处理。' TYPE 'I'.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* 全局对象
*---------------------------------------------------------------------*
DATA:
  go_app TYPE REF TO lcl_app.

*---------------------------------------------------------------------*
* 程序入口
*---------------------------------------------------------------------*
START-OF-SELECTION.

  CREATE OBJECT go_app.
  go_app->run( ).
