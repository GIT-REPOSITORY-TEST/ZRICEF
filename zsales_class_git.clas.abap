CLASS zsales_class_git DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gty_vbap,
        vbeln TYPE vbeln_va,
        posnr TYPE posnr_va,
        matnr TYPE matnr,
        charg TYPE charg_d,
        matkl TYPE matkl,
        zmeng TYPE dzmeng,
        meins TYPE meins,
        erdat TYPE erdat,
      END OF gty_vbap .
    TYPES:
      gtt_t_vbap TYPE TABLE OF gty_vbap .

    DATA gt_vbap TYPE gtt_t_vbap .

    METHODS fetch_data
      IMPORTING
        VALUE(it_vbeln) TYPE /accgo/cas_tt_vbeln_va_range .
    METHODS display_alv .
protected section.
private section.
ENDCLASS.



CLASS ZSALES_CLASS_GIT IMPLEMENTATION.


  METHOD display_alv.

    DATA: go_table TYPE REF TO cl_salv_table.

    IF gt_vbap IS NOT INITIAL.
      TRY.
          cl_salv_table=>factory( IMPORTING r_salv_table = go_table
                                  CHANGING  t_table      = gt_vbap ).
        CATCH cx_salv_msg INTO DATA(lo_msg).
          DATA(ls_msg) = lo_msg->get_message( ).
          MESSAGE ID   ls_msg-msgid
                TYPE   ls_msg-msgty
                NUMBER ls_msg-msgno
                  WITH ls_msg-msgv1
                       ls_msg-msgv2
                       ls_msg-msgv3
                       ls_msg-msgv4.
      ENDTRY.

      IF go_table IS NOT BOUND.
        RETURN.
      ENDIF.

      go_table->display( ).

    ENDIF.
  ENDMETHOD.


  METHOD fetch_data.
    IF it_vbeln IS NOT INITIAL.
      SELECT vbeln,
             posnr,
             matnr
*             charg
*             werks
*             matkl " Changes done as part of Change request #123
        FROM vbap ##DB_FEATURE_MODE[TABLE_LEN_MAX1]
        INTO TABLE @gt_vbap
        WHERE vbeln IN @it_vbeln
        ORDER BY vbeln,
                 posnr.
      IF sy-subrc <> 0 .
        MESSAGE 'No data found' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
