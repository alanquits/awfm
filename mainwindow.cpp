/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtCore/QLibraryInfo>
#include <QtWidgets/QApplication>
#include <QtWidgets/QAction>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QMessageBox>
#include <QFileDialog>

#include "mainwindow.h"
#include "aquiferdrawdowndlg.h"
#include "editwellsdlg.h"
#include "timeseriesdlg.h"
#include "theis.h"
#include "modelio.h"
#include "unitsdlg.h"
#include "welllossdlg.h"

// ![0]


MainWindow::MainWindow()
{
    createActions();
    createMenus();
    initWidgets();
    setDirty(false);
    setModelLoaded(false);

    setWindowTitle(tr("Analytic Well Field Modeler"));
    showMaximized();
}

MainWindow::~MainWindow()
{
}
//! [1]


//! [4]
void MainWindow::createActions()
{
    newAct = new QAction(tr("&New"), this);
    newAct->setShortcuts(QKeySequence::New);
    connect(newAct, &QAction::triggered, this, &MainWindow::newFile);

    openAct = new QAction(tr("&Open"), this);
    openAct->setShortcuts(QKeySequence::Open);
    connect(openAct, &QAction::triggered, this, &MainWindow::openModel);

    saveAct = new QAction(tr("&Save"), this);
    saveAct->setShortcuts(QKeySequence::Save);
    connect(saveAct, &QAction::triggered, this, &MainWindow::saveModel);

    saveAsAct = new QAction(tr("Save &As"), this);
    saveAsAct->setShortcuts(QKeySequence::SaveAs);
    connect(saveAsAct, &QAction::triggered, this, &MainWindow::saveModelAs);

    exitAct = new QAction(tr("E&xit"), this);
    exitAct->setShortcuts(QKeySequence::Quit);
    connect(exitAct, SIGNAL(triggered()), this, SLOT(close()));

    unitsAct = new QAction(tr("&Units"), this);
    connect(unitsAct, &QAction::triggered, this, &MainWindow::editUnits);

    wellsAct = new QAction(tr("&Wells"), this);
    connect(wellsAct, &QAction::triggered, this, &MainWindow::editWells);

    pumpingRatesAct = new QAction(tr("&Pumping Rates"), this);
    connect(pumpingRatesAct, &QAction::triggered, this, &MainWindow::editPumpingRates);

    aquiferDrawdownAct = new QAction(tr("&Aquifer Drawdown"), this);
    connect(aquiferDrawdownAct, &QAction::triggered, this, &MainWindow::editAquiferDrawdownMethod);

    wellLossAct = new QAction(tr("Well &Loss"), this);
    connect(wellLossAct, &QAction::triggered, this, &MainWindow::editWellLoss);

    runModelAct = new QAction(tr("&Run"), this);
    connect(runModelAct, &QAction::triggered, this, &MainWindow::runModel);

    pestSettingsAct = new QAction(tr("&Settings"), this);
    connect(pestSettingsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    observedHeadAct = new QAction(tr("Observed &Heads"), this);
    connect(observedHeadAct, &QAction::triggered, this, &MainWindow::editObservedHeads);

    windowsAct = new QAction(tr("&Windows"), this);
    connect(windowsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    runPestAct = new QAction(tr("&Run"), this);
    connect(runPestAct, &QAction::triggered, this, &MainWindow::dummySlot);
}


void MainWindow::createMenus()
{
    fileMenu = new QMenu(tr("&File"), this);
    fileMenu->addAction(newAct);
    fileMenu->addAction(openAct);
    fileMenu->addAction(saveAct);
    fileMenu->addAction(saveAsAct);
    fileMenu->addAction(exitAct);
    menuBar()->addMenu(fileMenu);

    modelMenu = new QMenu(tr("&Model"), this);
    modelMenu->addAction(unitsAct);
    modelMenu->addAction(wellsAct);
    modelMenu->addAction(pumpingRatesAct);
    modelMenu->addAction(aquiferDrawdownAct);
    modelMenu->addAction(wellLossAct);
    modelMenu->addSeparator();
    modelMenu->addAction(runModelAct);
    menuBar()->addMenu(modelMenu);

    pestMenu = new QMenu(tr("&Parameter Estimation"), this);
    pestMenu->addAction(pestSettingsAct);
    pestMenu->addAction(observedHeadAct);
    pestMenu->addAction(windowsAct);
    pestMenu->addSeparator();
    pestMenu->addAction(runPestAct);
    menuBar()->addMenu(pestMenu);


}

void MainWindow::initWidgets()
{
    viewTimeseriesWidget = new ViewTimeseriesWidget();
    setCentralWidget(viewTimeseriesWidget);
    connect(this, SIGNAL(modelChanged()),
            viewTimeseriesWidget, SLOT(drawChart()));
}

bool MainWindow::okToProceed()
{
    if (isDirty_) {
        int ret = QMessageBox::warning(this, tr("AWFM"),
            tr("The current model has unsaved changes.\n"
               "What would you like to do?"),
               QMessageBox::Save | QMessageBox::Discard
               | QMessageBox::Cancel,
               QMessageBox::Save);

        switch (ret) {
            case QMessageBox::Save:
                saveModel();
                return true;
            case QMessageBox::Discard:
                return true;
            case QMessageBox::Cancel:
                return false;
        }
    } else {
        return true;
    }
}

void MainWindow::setDirty(bool dirty)
{
    isDirty_ = dirty;
    saveAct->setEnabled(dirty);
}

void MainWindow::setModelLoaded(bool loaded)
{
    modelMenu->setEnabled(loaded);
    pestMenu->setEnabled(loaded);
    saveAsAct->setEnabled(loaded);
    viewTimeseriesWidget->setModel(&model_);
    modelLoaded_ = loaded;
    if (!loaded) {
        modelFileName_ = "";
    }
    emit modelChanged();
}

void MainWindow::newFile()
{
    if (okToProceed()) {
        model_ = awfm::Model();
        modelFileName_ = "";
        setDirty(true);
        setModelLoaded(true);
    }
}

void MainWindow::editAquiferDrawdownMethod()
{
    AquiferDrawdownDlg dlg(&model_);
    if (dlg.exec()) {
        awfm::AquiferDrawdownModel model_type = dlg.aquiferDrawdownModel();
        if (model_type == awfm::THEIS) {
            double S = dlg.storativity();
            double T = dlg.transmissivity();
            model_.setAquiferDrawdownModel(new awfm::Theis(S, T));
        } else if (model_type == awfm::HANTUSHJACOB) {
            double S = dlg.storativity();
            double T = dlg.transmissivity();
            double mpOverKp = dlg.mpOverKp();
            //model_.setAquiferDrawdownModel(awfm::HantushJacob(S, T, mpOverKp); // TODO
        }
        setDirty(true);
        emit modelChanged();
    }

}

void MainWindow::editUnits()
{
    UnitsDlg dlg(&model_);
    if (dlg.exec()) {
        model_.setDischargeUnit(dlg.dischargeUnit());
        model_.setLengthUnit(dlg.lengthUnit());
        model_.setTimeUnit(dlg.timeUnit());
        emit modelChanged();
    }
}

void MainWindow::editWells()
{
    EditWellsDlg dlg(&model_);
    if (dlg.exec()) {
        model_.setWells(dlg.wells());
        setDirty(true);
        viewTimeseriesWidget->setModel(&model_);
        emit modelChanged();
    }

}

void MainWindow::editWellLoss()
{
    WellLossDlg dlg(&model_);
    if (dlg.exec()) {
        QList< QMap<QString, double> > data = dlg.tableData();
        for (int i = 0; i < data.size(); i++) {
            model_.wellRef(i)->setB(data[i]["b"]);
            model_.wellRef(i)->setC(data[i]["c"]);
            model_.wellRef(i)->setDeltaB(data[i]["db"]);
            model_.wellRef(i)->setDeltaC(data[i]["dc"]);
        }

        QMap<QString, bool> options = dlg.getOptions();
        foreach(QString key, options.keys()) {
            model_.setOption(key, options[key]);
        }
        emit modelChanged();
    }
}

void MainWindow::editPumpingRates()
{
    QStringList well_names;
    QList<awfm::Timeseries> timeseries_list;

    QList<awfm::Well> wells = model_.wells();
    for (int i = 0; i < wells.size(); i++) {
        well_names.push_back(wells[i].name());
        timeseries_list.push_back(wells[i].q());
    }

    TimeseriesDlg dlg(well_names, timeseries_list,
                      "Edit Pumping Rates", "Q");

    if (dlg.exec()) {
            timeseries_list = dlg.timeseriesList();
            int i = 0;
            foreach(awfm::Timeseries ts, timeseries_list) {
                model_.wellRef(i)->setQ(ts);
                i++;
            }
            setDirty(true);
            emit modelChanged();
    }
}

void MainWindow::editObservedHeads()
{
    QStringList well_names;
    QList<awfm::Timeseries> timeseries_list;

    QList<awfm::Well> wells = model_.wells();
    for (int i = 0; i < wells.size(); i++) {
        well_names.push_back(wells[i].name());
        timeseries_list.push_back(wells[i].wl());
    }

    TimeseriesDlg dlg(well_names, timeseries_list,
                      "Edit Observed Water Levels", "h");

    if (dlg.exec()) {
            timeseries_list = dlg.timeseriesList();
            int i = 0;
            foreach(awfm::Timeseries ts, timeseries_list) {
                model_.wellRef(i)->setWl(ts);
                i++;
            }
            setDirty(true);
            emit modelChanged();
    }
}

void MainWindow::runModel()
{
    model_.run();
    emit modelChanged();
}

void MainWindow::openModel()
{
    if (okToProceed()) {
        QString err_msg;
        QString file_name = QFileDialog::getOpenFileName(this,
            tr("Open Model"), ".",
            tr("SQLite Files (*.db)"));

        if (file_name.isEmpty()) {
            setModelLoaded(false);
            return;
        }

        if (awfm::ModelIO::load(&model_, file_name, &err_msg)) {
            modelFileName_ = file_name;
            setModelLoaded(true);
        } else {
            QMessageBox::warning(this, "Load Error",
                err_msg, QMessageBox::Ok);
        }
    }
}

void MainWindow::saveModel()
{
    if (!modelFileName_.isEmpty()) {
        if (awfm::Utility::fileExists(modelFileName_)) {
            QFile(modelFileName_).remove();
        }
        QString err_msg;
        if (!awfm::ModelIO::save(&model_, modelFileName_, &err_msg)) {
            QMessageBox::warning(this, "Save Error", err_msg, QMessageBox::Ok);
        } else {
            setDirty(false);
        }
    } else {
        saveModelAs();
    }
}

void MainWindow::saveModelAs()
{
    QString fileName = QFileDialog::getSaveFileName(this, tr("Save File"),
                               ".",
                               tr("SQLite (*.db)"));
    if (fileName.isEmpty()) {
        return;
    }

    if (QFileInfo(QFile(fileName)).suffix() == "db") {
        modelFileName_ = fileName;
    } else {
        modelFileName_ = fileName + ".db";
    }
    saveModel();
}

void MainWindow::dummySlot()
{
    return;
}
