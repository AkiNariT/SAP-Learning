TYPES: BEGIN OF ty_sum,
         kunnr TYPE kunnr,
         waerk TYPE waerk,
         total TYPE netwr,
       END OF ty_sum.

DATA: lt_sum TYPE STANDARD TABLE OF ty_sum,
      ls_sum TYPE ty_sum.

LOOP AT lt_data INTO DATA(ls_data).

  READ TABLE lt_sum INTO ls_sum
    WITH KEY kunnr = ls_data-kunnr
             waerk = ls_data-waerk.

  IF sy-subrc = 0.
    ls_sum-total = ls_sum-total + ls_data-netwr.
    MODIFY lt_sum FROM ls_sum INDEX sy-tabix.
  ELSE.
    CLEAR ls_sum.
    ls_sum-kunnr = ls_data-kunnr.
    ls_sum-waerk = ls_data-waerk.
    ls_sum-total = ls_data-netwr.
    APPEND ls_sum TO lt_sum.
  ENDIF.

ENDLOOP.
