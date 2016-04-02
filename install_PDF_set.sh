#! /bin/bash

cd share/LHAPDF/

LHAPDF_version=6.1.6
PDFs="NNPDF30_lo_as_0130 NNPDF30_lo_as_0130_nf_4 NNPDF30_lo_as_0118 NNPDF23_lo_as_0130_qed NNPDF23_lo_as_0119_qed cteq6l1 MMHT2014lo68cl MMHT2014lo_asmzsmallrange HERAPDF15LO_EIG NNPDF30_nlo_as_0118 NNPDF23_nlo_as_0119 CT10nlo MMHT2014nlo68cl"

for PDF in $PDFs; do
  echo "Installing $PDF PDF set"
  curl -O -L https://www.hepforge.org/archive/lhapdf/pdfsets/$LHAPDF_version/$PDF.tar.gz
  tar xf $PDF.tar.gz
  rm $PDF.tar.gz
done;


